import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:kalil_adt_annotation/kalil_adt_annotation.dart';
import 'package:kalil_utils/utils.dart' hide Tuple;
import 'package:libuno/server.dart';
import 'package:libuno/threaded_state_machine.dart';
import 'package:uuid/uuid.dart';
import 'dart:collection';
import 'client.dart';
import 'data.dart';
import 'state_machine.dart';
import 'package:meta/meta.dart';

class BasicServer extends UnoServer {
  int id = 0;
  UnoPlayerId? _admin;
  final List<UnoPlayerId> _players = [];
  bool isPaused = true;
  late StreamSubscription<void> ticker;
  final Set<UnoPlayerId> bots = {};
  Future<void> start() async {
    ticker = Stream.periodic(Duration(milliseconds: 500))
        .listen((event) => stateMachine.dispatch(TimePassed()));
    isPaused = false;
    _currentPlayer.listen((playerId) async {
      print("TURN OF $playerId");
      if (bots.contains(playerId)) {
        await Future.delayed(Duration(seconds: 5));
        await _playBot(playerId!);
      }
    });
  }

  Future<bool> _playBot(UnoPlayerId bot) {
    final player = stateMachine.currentState.players[bot]!;
    final cards = player.cards.toList();
    final lastColor = stateMachine.currentState.currentColor;
    final lastCard = stateMachine.currentState.cardStack.last;
    for (final card in cards.toList()) {
      if (!card.visitC(
        defaultCard: (c, i) =>
            c == lastColor || (lastCard is DefaultCard && lastCard.number == i),
        reverseCard: (c) => c == lastColor || lastCard is ReverseCard,
        blockCard: (c) => c == lastColor || lastCard is BlockCard,
        plusTwoCard: (c) => c == lastColor || lastCard is PlusTwoCard,
        plusFourCard: () => true,
        rainbowCard: () => true,
      )) {
        cards.remove(card);
      }
    }
    if (cards.isEmpty) {
      return sendClientEvent(bot, PlayerDrewCard());
    }
    final r = Random();
    return sendClientEvent(
      bot,
      PlayCard(
        player.cards.indexOf(cards[r.nextInt(cards.length)]),
        UnoCardColor.values[r.nextInt(UnoCardColor.values.length)],
      ),
    );
  }

  Stream<UnoPlayerId?> get _currentPlayer => stateMachine.state
      .map(
        (state) => state.play.visit(
          unoPlaying: (p) => p.currentPlayer,
          unoWaitingStart: (_) => null,
          unoFinished: (_) => null,
        ),
      )
      .distinct();

  @override
  Future<void> addBot(UnoPlayerId requestingPlayer) async {
    if (requestingPlayer != _admin) {
      return;
    }
    final id = UnoPlayerId("${this.id++}");
    bots.add(id);
    await stateMachine.dispatch(AddPlayer(id, "Bot ${id.unwrap}"));
  }

  @override
  Future<UnoPlayerId> addPlayer(String name) async {
    final id = UnoPlayerId("${this.id++}");

    _admin ??= id;

    _players.add(id);
    await stateMachine.dispatch(AddPlayer(id, name));
    return id;
  }

  @override
  Future<UnoClientState> currentState(UnoPlayerId player) async =>
      unoStateToUnoClientState(player, stateMachine.currentState);

  @override
  Future<void> removePlayer(
      UnoPlayerId requestingPlayer, UnoPlayerId player) async {
    if (requestingPlayer != _admin && requestingPlayer != player) {
      return;
    }
    _players.remove(player);
    await stateMachine.dispatch(RemovePlayer(player));
  }

  @override
  Future<bool> sendClientEvent(UnoPlayerId player, UnoEvent e) async {
    if (e is TimePassed) {
      return false;
    }
    if (e is ChangePlayerName && player == e.id ||
        e is RemovePlayer && player == e.id) {
      if (e is RemovePlayer) {
        _players.remove(player);
      }
      return stateMachine.dispatch(e);
    }
    if (e is StartGame && player != _admin) {
      return false;
    }
    if (e is RemovePlayer && player == _admin) {
      _players.remove(player);
      _admin = _players.firstWhereOrNull((id) => id != player);
    }
    return stateMachine.currentState.play.visit(
      unoPlaying: (playing) {
        if (playing.currentPlayer == player || e is PlayerSnitchedUno) {
          return stateMachine.dispatch(e);
        }
        return false;
      },
      unoWaitingStart: (_) => stateMachine.dispatch(e),
      unoFinished: (_) => stateMachine.dispatch(e),
    );
  }

  @override
  Future<void> startGame(UnoPlayerId requestingPlayer) async {
    if (requestingPlayer != _admin) {
      return;
    }
    await stateMachine.dispatch(StartGame());
  }

  @override
  Stream<UnoClientState> state(UnoPlayerId player) =>
      stateMachine.state.map(unoStateToUnoClientState.curry(player));

  @override
  final UnoStateMachine stateMachine = ActualUnoStateMachine(
    GameParameters(
      7,
      Duration(seconds: 10),
      Duration(seconds: 10),
      {},
    ),
  );

  @override
  Future<GameParameters> getParameters() async => stateMachine.parameters;

  @override
  Future<String> getInstructions() async => "Um jogo uno";

  Future<bool> resetGame() async {
    return false;
  }
}

UnoClientState unoStateToUnoClientState(
  UnoPlayerId player,
  UnoState state,
) =>
    UnoClientState(
      state.players.map(
        (key, value) => MapEntry(
          key,
          PlayerClientState(
            value.id,
            value.name,
            value.cards.length,
            value.lastPlayTime,
            value.didUno,
          ),
        ),
      ),
      state.players[player]!,
      state.playedCards,
      state.cardStack.length,
      state.currentColor,
      state.play,
    );

abstract class UnoServer {
  Future<void> start();
  Future<GameParameters> getParameters();
  Future<UnoPlayerId> addPlayer(String name);
  Future<void> addBot(UnoPlayerId requestingPlayer);
  Future<UnoClientState> currentState(UnoPlayerId player);
  Stream<UnoClientState> state(UnoPlayerId player);
  Future<bool> sendClientEvent(UnoPlayerId player, UnoEvent e);
  Future<void> startGame(UnoPlayerId requestingPlayer);
  Future<void> removePlayer(UnoPlayerId requestingPlayer, UnoPlayerId player);
  Future<String> getInstructions();
  Future<bool> resetGame();
}
