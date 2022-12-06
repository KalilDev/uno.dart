import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:math';

import 'package:kalil_utils/utils.dart';
import 'package:libuno/data.dart';
import 'package:libuno/server.dart';
import 'package:libuno/state_machine.dart';
import 'native.dart' as native;
import '../client.dart';
import 'native_d.dart' as d;

class UnoNativeServer extends UnoServer {
  late String playerName;
  final GameParameters gameParameters;
  late final Pointer<native.Interface> interface;
  final Map<UnoPlayerId, DateTime> lastPlayTime = {};
  UnoPlayState playState = UnoWaitingStart();
  final admin = UnoPlayerId("0");
  final native.CAPI capi;
  Stream<UnoState> get _state {
    final listener = StreamController<UnoState>()..add(_currentState);
    listeners.add(listener);
    listener.onCancel = () => listeners.remove(listener);
    return listener.stream;
  }

  bool isPaused = true;
  late StreamSubscription<void> ticker;
  final Set<UnoPlayerId> bots = {
    UnoPlayerId("1"),
    UnoPlayerId("2"),
    UnoPlayerId("3"),
  };
  Future<void> start() async {
    playerName = "Pedro";
    ticker = Stream.periodic(Duration(milliseconds: 500)).listen(_onTicker);
    isPaused = false;
    _currentPlayer.listen((playerId) async {
      print("TURN OF $playerId");
      if (bots.contains(playerId)) {
        await Future.delayed(Duration(seconds: 3));
        await _playBot();
      }
    });
    final now = DateTime.now();
    lastPlayTime[UnoPlayerId("0")] = now;
    lastPlayTime[UnoPlayerId("1")] = now;
    lastPlayTime[UnoPlayerId("2")] = now;
    lastPlayTime[UnoPlayerId("3")] = now;
    _vencedor.listen((v) {
      if (v == -1) {
        return;
      }

      playState = UnoFinished(
        UnoPlayerId(v.toString()),
        DateTime.now().difference((playState as UnoPlaying).playStartTime),
      );
      _notifyListeners();
    });
  }

  Future<bool> resetGame() async {
    final now = DateTime.now();
    lastPlayTime[UnoPlayerId("0")] = now;
    lastPlayTime[UnoPlayerId("1")] = now;
    lastPlayTime[UnoPlayerId("2")] = now;
    lastPlayTime[UnoPlayerId("3")] = now;
    playState = UnoWaitingStart();
    capi.interface_resetar(interface);
    _notifyListeners();
    return true;
  }

  Future<bool> _playBot() async {
    final ps = playState;
    if (ps is! UnoPlaying) {
      return false;
    }
    final partida = capi.interface_get_partida(interface);
    capi.partida_jogar_bot(partida);

    playState = ps.copyWith(
      playStartTime: DateTime.now().just,
      playRemainingDuration: gameParameters.playDuration.just,
      currentPlayer:
          UnoPlayerId(capi.partida_get_jogador_atual(partida).toString()).just,
    );
    _notifyListeners();
    return true;
  }

  Stream<UnoPlayerId?> get _currentPlayer => _state
      .map(
        (state) => state.play.visit(
          unoPlaying: (p) => p.currentPlayer,
          unoWaitingStart: (_) => null,
          unoFinished: (_) => null,
        ),
      )
      .distinct();

  UnoNativeServer(this.capi)
      : gameParameters = GameParameters(
          7,
          Duration(seconds: 20),
          Duration(seconds: 10),
          {},
        ) {
    interface = capi.interface_new();
  }
  Future<GameParameters> getParameters() async => gameParameters;
  Future<UnoPlayerId> addPlayer(String name) async {
    playerName = name;
    return admin;
  }

  UnoState get _currentState {
    print("current state");
    final partida = capi.interface_get_partida(interface);
    final players = {
      for (final jogador in capi.iterateJogador(partida))
        ...(() {
          final idJogador = capi.jogador_get_id(jogador);
          final unoPlayerId = UnoPlayerId(idJogador.toString());
          final mao = capi.jogador_get_mao(jogador);
          final maoSize = capi.mao_size(mao);
          final state = UnoPlayerState(
            unoPlayerId,
            idJogador == 0 ? playerName : "Bot $idJogador",
            capi
                .iteratePtr(capi.mao_begin(mao), capi.mao_end(mao))
                .map((p) => capi.carta_to_uno_card(p.value))
                .toList(),
            lastPlayTime[unoPlayerId] ?? DateTime.now(),
            maoSize == 1,
          );
          return {unoPlayerId: state};
        })()
    };
    final playedCards = capi.partida_get_cartas_na_mesa(partida);
    final cardStack = capi.partida_get_cartas_para_comer(partida);
    return UnoState(
      players,
      Queue.of(capi
          .iteratePtr(
              capi.pilha_begin(playedCards), capi.pilha_end(playedCards))
          .map((p) => capi.carta_to_uno_card(p.value))),
      Queue.of(capi
          .iteratePtr(capi.pilha_begin(cardStack), capi.pilha_end(cardStack))
          .map((p) => capi.carta_to_uno_card(p.value))),
      capi.cor_da_carta_to_uno_card_color(
          capi.partida_get_cor_da_partida(partida)),
      playState,
    );
  }

  Future<void> addBot(UnoPlayerId requestingPlayer) async {}
  UnoClientState _currentStateFor(UnoPlayerId playerId) =>
      unoStateToUnoClientState(playerId, _currentState);

  Future<UnoClientState> currentState(UnoPlayerId playerId) async =>
      _currentStateFor(playerId);

  final Set<StreamController<UnoState>> listeners = {};

  Stream<UnoClientState> state(UnoPlayerId player) {
    final listener = StreamController<UnoState>()..add(_currentState);
    listeners.add(listener);
    listener.onCancel = () => listeners.remove(listener);
    return listener.stream
        .map((state) => unoStateToUnoClientState(player, state));
  }

  Stream<int> get _vencedor => _state
      .map((_) =>
          capi.partida_get_vencedor(capi.interface_get_partida(interface)))
      .distinct();

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
          final partida = capi.interface_get_partida(interface);
          final id_jogador = int.parse(player.unwrap);
          try {
            capi.partida_jogar_carta(partida, id_jogador, i);
          } on Exception catch (e) {
            capi.partida_comer_carta(partida, id_jogador);
          }
          final now = DateTime.now();
          lastPlayTime[player] = now;
          final jogador_atual = capi.partida_get_jogador_atual(partida);
          playState = playing.copyWith(
            playStartTime: now.just,
            playRemainingDuration: gameParameters.playDuration.just,
            currentPlayer: UnoPlayerId(jogador_atual.toString()).just,
          );
          _notifyListeners();
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
        capi.interface_delete(interface);
        return true;
      },
      timePassed: () => false,
      playerDrewCard: () => playState.visit(
        unoPlaying: (playing) {
          if (playing.currentPlayer != player) {
            return false;
          }
          final partida = capi.interface_get_partida(interface);
          capi.partida_comer_carta(partida, int.parse(player.unwrap));
          final now = DateTime.now();
          lastPlayTime[player] = now;
          final jogador_atual = capi.partida_get_jogador_atual(partida);
          playState = playing.copyWith(
            playStartTime: DateTime.now().just,
            playRemainingDuration: gameParameters.playDuration.just,
            currentPlayer: UnoPlayerId(jogador_atual.toString()).just,
          );
          _notifyListeners();
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
      final partida = capi.interface_get_partida(interface);
      var jogador_atual = capi.partida_get_jogador_atual(partida);
      final now = DateTime.now();
      lastPlayTime[UnoPlayerId(jogador_atual.toString())] = now;
      capi.partida_comer_carta(partida, jogador_atual);
      jogador_atual = capi.partida_get_jogador_atual(partida);
      playState = ps.copyWith(
        playStartTime: now.just,
        playRemainingDuration: gameParameters.playDuration.just,
        currentPlayer: UnoPlayerId(jogador_atual.toString()).just,
      );
      _notifyListeners();
      return;
    }
    final remainingDuration = gameParameters.playDuration - playDuration;
    playState = ps.copyWith(playRemainingDuration: remainingDuration.just);
    _notifyListeners();
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
    final partida = capi.interface_get_partida(interface);
    final direcao = capi.partida_get_direcao(partida);
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
      capi.direcao_da_partida_to_uno_direction(direcao),
      Queue(),
    );
    _notifyListeners();
  }

  void _notifyListeners() {
    final currentState = _currentState;
    for (final listener in listeners) {
      listener.add(currentState);
    }
  }

  Future<void> removePlayer(
      UnoPlayerId requestingPlayer, UnoPlayerId player) async {}

  @override
  Future<String> getInstructions() async =>
      capi.interface_get_instrucoes(interface);
}
