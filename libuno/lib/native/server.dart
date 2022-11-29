import 'dart:async';
import 'dart:collection';
import 'dart:ffi';

import 'package:kalil_utils/utils.dart';
import 'package:libuno/data.dart';
import 'package:libuno/server.dart';
import 'package:libuno/state_machine.dart';
import 'native.dart';
import '../client.dart';

Pointer<T> itNextPtr<T extends NativeType>(Pointer<T> it) =>
    Pointer.fromAddress(it.address + sizeOf<Pointer<Void>>());
Iterable<Pointer<T>> iteratePtr<T extends NativeType>(
    Pointer<T> begin, Pointer<T> end) sync* {
  for (var it = begin; it != end; it = itNextPtr(it)) {
    yield it;
  }
}

Iterable<Pointer<Jogador>> iterateJogador(Pointer<Partida> self) sync* {
  for (var i = 0; i < partida_size(self); i++) {
    yield partida_at(self, i);
  }
}

UnoCardColor cor_da_carta_to_uno_card_color(CorDaCarta cor) {
  switch (cor) {
    case CorDaCarta.amarelo:
      return UnoCardColor.yellow;
    case CorDaCarta.azul:
      return UnoCardColor.blue;
    case CorDaCarta.verde:
      return UnoCardColor.green;
    case CorDaCarta.vermelho:
      return UnoCardColor.red;
  }
}

UnoCard carta_to_uno_card(Pointer<Carta> carta) {
  final especial = cast_carta_to_carta_especial(carta);
  final cor = cor_da_carta_to_uno_card_color(carta_get_cor(carta));
  if (especial != nullptr) {
    final tipo = carta_especial_get_tipo(especial);
    switch (tipo) {
      case TipoDeCartaEspecial.bloqueia:
        return UnoCard.blockCard(cor);
      case TipoDeCartaEspecial.comeDois:
        return UnoCard.plusTwoCard(cor);
      case TipoDeCartaEspecial.reverso:
        return UnoCard.reverseCard(cor);
    }
  }
  return UnoCard.defaultCard(
    cor,
    carta_get_numero(carta),
  );
}

UnoDirection direcao_da_partida_to_uno_direction(DirecaoDaPartida direcao) {
  switch (direcao) {
    case DirecaoDaPartida.normal:
      return UnoDirection.clockwise;
    case DirecaoDaPartida.reversa:
      return UnoDirection.counterClockwise;
  }
}

class UnoNativeServer extends UnoServer {
  late final String playerName;
  final GameParameters gameParameters;
  final Pointer<Interface> interface = interface_new();
  final Map<UnoPlayerId, DateTime> lastPlayTime = {};
  UnoPlayState playState = UnoWaitingStart();
  final admin = UnoPlayerId("0");
  final StreamController _streamController = StreamController<void>.broadcast();
  late final StreamSubscription<void> _ticker;

  UnoNativeServer()
      : gameParameters = GameParameters(
          7,
          Duration(seconds: 20),
          Duration(seconds: 10),
          {},
        );
  Future<GameParameters> getParameters() async => gameParameters;
  Future<UnoPlayerId> addPlayer(String name) async {
    playerName = name;
    return admin;
  }

  Future<void> addBot(UnoPlayerId requestingPlayer) async {}
  UnoClientState _currentState(UnoPlayerId playerId) {
    final playerIdInt = int.parse(playerId.unwrap);
    final partida = interface_get_partida(interface);
    final jogador = partida_at(partida, playerIdInt);
    final mao = jogador_get_mao(jogador);
    final player = UnoPlayerState(
      playerId,
      playerIdInt == 0 ? playerName : "Bot $playerIdInt",
      iteratePtr(mao_begin(mao), mao_end(mao))
          .map((p) => carta_to_uno_card(p.value))
          .toList(),
      lastPlayTime[playerId] ?? DateTime.now(),
      mao_size(mao) == 1,
    );
    final players = {
      for (final jogador in iterateJogador(partida))
        ...(() {
          final idJogador = jogador_get_id(jogador);
          final unoPlayerId = UnoPlayerId(idJogador.toString());
          final mao = jogador_get_mao(jogador);
          final maoSize = mao_size(mao);
          final state = PlayerClientState(
            unoPlayerId,
            idJogador == 0 ? playerName : "Bot $idJogador",
            maoSize,
            lastPlayTime[unoPlayerId] ?? DateTime.now(),
            maoSize == 1,
          );
          return {unoPlayerId: state};
        })()
    };
    final playedCards = partida_get_cartas_na_mesa(partida);
    final cardStack = partida_get_cartas_para_comer(partida);
    return UnoClientState(
      players,
      player,
      Queue.of(iteratePtr(pilha_begin(playedCards), pilha_end(playedCards))
          .map((p) => carta_to_uno_card(p.value))),
      pilha_size(cardStack),
      cor_da_carta_to_uno_card_color(partida_get_cor_da_partida(partida)),
      playState,
    );
  }

  Future<UnoClientState> currentState(UnoPlayerId playerId) async =>
      _currentState(playerId);

  Stream<UnoClientState> state(UnoPlayerId player) =>
      (StreamController<UnoClientState>()
            ..add(_currentState(player))
            ..addStream(
                _streamController.stream.map((_) => _currentState(player))))
          .stream;

  void _playBot() {
    final playing = playState;
    if (playing is! UnoPlaying) {
      return;
    }
    final partida = interface_get_partida(interface);
    var jogador_atual = partida_get_jogador_atual(partida);
    partida_jogar_bot(partida);
    final now = DateTime.now();
    lastPlayTime[UnoPlayerId(jogador_atual.toString())] = now;
    final vencedor = partida_get_vencedor(partida);
    if (vencedor != -1) {
      playState = UnoFinished(
        UnoPlayerId(vencedor.toString()),
        DateTime.now().difference((playState as UnoPlaying).playStartTime),
      );
      _streamController.add(null);
      return;
    }
    jogador_atual = partida_get_jogador_atual(partida);
    playState = playing.copyWith(
      playStartTime: now.just,
      playRemainingDuration: gameParameters.playDuration.just,
      currentPlayer: UnoPlayerId(jogador_atual.toString()).just,
    );
    _streamController.add(null);
  }

  Future<bool> sendClientEvent(UnoPlayerId player, UnoEvent e) async {
    return await e.visit(
      startGame: () async {
        final currState = playState;
        await startGame(player);
        return currState != playState;
      },
      playCard: (i, _) => playState.visit(
        unoPlaying: (playing) {
          if (playing.currentPlayer != player) {
            return false;
          }
          final partida = interface_get_partida(interface);
          partida_jogar_carta(partida, int.parse(player.unwrap), i);
          final now = DateTime.now();
          lastPlayTime[player] = now;
          final vencedor = partida_get_vencedor(partida);
          if (vencedor != -1) {
            playState = UnoFinished(
              UnoPlayerId(vencedor.toString()),
              DateTime.now()
                  .difference((playState as UnoPlaying).playStartTime),
            );
            _streamController.add(null);
            return true;
          }
          final jogador_atual = partida_get_jogador_atual(partida);
          playState = playing.copyWith(
            playStartTime: now.just,
            playRemainingDuration: gameParameters.playDuration.just,
            currentPlayer: UnoPlayerId(jogador_atual.toString()).just,
          );
          _streamController.add(null);
          return true;
        },
        unoWaitingStart: (_) => false,
        unoFinished: (_) => false,
      ),
      sayUno: () => false,
      addPlayer: (_, __) => false,
      changePlayerName: (_, __) => false,
      removePlayer: (p) {
        if (p != player) {
          return false;
        }
        interface_delete(interface);
        return true;
      },
      timePassed: () => false,
      playerDrewCard: () => playState.visit(
        unoPlaying: (playing) {
          if (playing.currentPlayer != player) {
            return false;
          }
          final partida = interface_get_partida(interface);
          partida_comer_carta(partida, int.parse(player.unwrap));
          final now = DateTime.now();
          lastPlayTime[player] = now;
          final jogador_atual = partida_get_jogador_atual(partida);
          playState = playing.copyWith(
            playStartTime: DateTime.now().just,
            playRemainingDuration: gameParameters.playDuration.just,
            currentPlayer: UnoPlayerId(jogador_atual.toString()).just,
          );
          _streamController.add(null);
          return true;
        },
        unoWaitingStart: (_) => false,
        unoFinished: (_) => false,
      ),
      playerSnitchedUno: (_) => false,
    );
  }

  void _onTicker([void _]) {
    final ps = playState;
    if (ps is! UnoPlaying) {
      return;
    }
    final now = DateTime.now();
    final playDuration = now.difference(ps.playStartTime);
    if (playDuration >= gameParameters.playDuration) {
      final partida = interface_get_partida(interface);
      var jogador_atual = partida_get_jogador_atual(partida);
      final now = DateTime.now();
      lastPlayTime[UnoPlayerId(jogador_atual.toString())] = now;
      partida_comer_carta(partida, jogador_atual);
      jogador_atual = partida_get_jogador_atual(partida);
      if (jogador_atual != 0) {
        Future.delayed(Duration(seconds: 5)).then((_) => _playBot());
      }
      playState = ps.copyWith(
        playStartTime: now.just,
        playRemainingDuration: gameParameters.playDuration.just,
        currentPlayer: UnoPlayerId(jogador_atual.toString()).just,
      );
      _streamController.add(null);
      return;
    }
    final remainingDuration = gameParameters.playDuration - playDuration;
    playState = ps.copyWith(playRemainingDuration: remainingDuration.just);
    _streamController.add(null);
  }

  Future<void> startGame(UnoPlayerId requestingPlayer) async {
    final start = playState.visit(
      unoPlaying: (_) => false,
      unoWaitingStart: (_) => requestingPlayer == admin,
      unoFinished: (_) => false,
    );
    if (!start) {
      return;
    }
    final partida = interface_get_partida(interface);
    final direcao = partida_get_direcao(partida);
    final now = DateTime.now();
    lastPlayTime[UnoPlayerId("0")] = now;
    lastPlayTime[UnoPlayerId("1")] = now;
    lastPlayTime[UnoPlayerId("2")] = now;
    lastPlayTime[UnoPlayerId("3")] = now;
    playState = UnoPlaying(
      now,
      now,
      gameParameters.playDuration,
      admin,
      direcao_da_partida_to_uno_direction(direcao),
      Queue(),
    );
    _ticker = Stream.periodic(Duration(milliseconds: 25)).listen(_onTicker);
    _streamController.add(null);
  }

  Future<void> removePlayer(
      UnoPlayerId requestingPlayer, UnoPlayerId player) async {}
}
