import 'dart:async';

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
  UnoPlayerId? _admin;
  final List<UnoPlayerId> _players = [];
  bool isPaused = true;
  late StreamSubscription<void> ticker;
  void start() {
    ticker = Stream.periodic(Duration(milliseconds: 500))
        .listen((event) => stateMachine.dispatch(TimePassed()));
    isPaused = false;
  }

  @override
  Future<void> addBot(UnoPlayerId requestingPlayer) async {
    if (requestingPlayer != _admin) {
      return;
    }
    final id = UnoPlayerId(Uuid().v4());
    await stateMachine.dispatch(AddPlayer(id, id.unwrap));
  }

  @override
  Future<UnoPlayerId> addPlayer(String name) async {
    final id = UnoPlayerId(Uuid().v4());
    if (_admin == null) {
      _admin = id;
    }
    _players.add(id);
    await stateMachine.dispatch(AddPlayer(id, name));
    return id;
  }

  @override
  Future<UnoClientState> currentState(UnoPlayerId player) async =>
      _unoStateToUnoClientState(player, stateMachine.currentState);

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

  UnoClientState _unoStateToUnoClientState(
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

  @override
  Stream<UnoClientState> state(UnoPlayerId player) =>
      stateMachine.state.map(_unoStateToUnoClientState.curry(player));

  @override
  final UnoStateMachine stateMachine = ActualUnoStateMachine(
    GameParameters(
      7,
      Duration(seconds: 5),
      Duration(seconds: 5),
      {
        UnoRule.plusFourStacksPlusFour,
        UnoRule.plusFourStacksPlusTwo,
        UnoRule.plusTwoStacksPlusTwo,
      },
    ),
  );

  @override
  Future<GameParameters> getParameters() async => stateMachine.parameters;
}

abstract class UnoServer {
  Future<GameParameters> getParameters();
  Future<UnoPlayerId> addPlayer(String name);
  Future<void> addBot(UnoPlayerId requestingPlayer);
  Future<UnoClientState> currentState(UnoPlayerId player);
  Stream<UnoClientState> state(UnoPlayerId player);
  Future<bool> sendClientEvent(UnoPlayerId player, UnoEvent e);
  Future<void> startGame(UnoPlayerId requestingPlayer);
  Future<void> removePlayer(UnoPlayerId requestingPlayer, UnoPlayerId player);
}
