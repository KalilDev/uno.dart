import 'dart:async';

import 'package:collection/collection.dart';
import 'package:kalil_adt_annotation/kalil_adt_annotation.dart';
import 'package:kalil_utils/utils.dart' hide Tuple;
import 'package:libuno/threaded_state_machine.dart';
import 'package:uuid/uuid.dart';
import 'dart:collection';
import 'data.dart';
import 'state_machine.dart';
import 'package:meta/meta.dart';
part 'client.g.dart';

@data(
  #PlayerClientState,
  [],
  Record(
    {
      #id: UnoPlayerIdT,
      #name: T(#String),
      #cardCount: T(#int),
      #lastPlayTime: T(#DateTime),
      #didUno: T(#bool),
    },
  ),
  deriveFromJson: true,
)
const Type _PlayerClientState = PlayerClientState;
typedef PlayerClientStates = Map<UnoPlayerId, PlayerClientState>;
const PlayerClientStatesT = T(
  #PlayerClientStates,
  toJson: '{}.map((id, v) => MapEntry(id.toJson(),  v))',
  fromJson: '''({} as Map<String, Object?>)
              .map((id,v) =>
                MapEntry(UnoPlayerId.fromJson(id), PlayerClientState.fromJson(v!))
              )''',
);

@data(
  #UnoClientState,
  [],
  Record(
    {
      #players: PlayerClientStatesT,
      #player: UnoPlayerStateT,
      #playedCards: UnoCardsT,
      #cardStackLength: T(#int),
      #currentColor: UnoCardColorT,
      #play: UnoPlayStateT,
    },
  ),
  deriveFromJson: true,
)
const Type _UnoClientState = UnoClientState;

abstract class BaseClient extends UnoClient {
  @protected
  Future<bool> sendEvent(UnoEvent e);
  @override
  Future<bool> changeName(String name) => sendEvent(ChangePlayerName(id, name));

  @override
  Future<bool> drawCard() => sendEvent(PlayerDrewCard());
  @override
  Future<bool> playCard(int i, [UnoCardColor? chosenWildcardColor]) =>
      sendEvent(PlayCard(i, chosenWildcardColor));

  @override
  Future<void> quit() => sendEvent(RemovePlayer(id));

  @override
  Future<bool> sayUno() => sendEvent(SayUno());

  @override
  Future<bool> snitchUno(UnoPlayerId player) =>
      sendEvent(PlayerSnitchedUno(player));

  @override
  Future<void> startGame() => sendEvent(StartGame());
}

class DirectClient extends BaseClient {
  final UnoPlayerId id;
  final UnoServer server;

  DirectClient(this.id, this.server);

  @override
  Future<bool> sendEvent(UnoEvent e) => server.sendClientEvent(id, e);

  @override
  Future<UnoClientState> get currentState => server.currentState(id);

  @override
  Stream<UnoClientState> get state => server.state(id);

  @override
  Future<void> addBot() => server.addBot(id);
}

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

abstract class UnoClient {
  UnoPlayerId get id;
  Future<UnoClientState> get currentState;
  Stream<UnoClientState> get state;
  Future<void> addBot();
  Future<void> startGame();
  Future<bool> drawCard();
  Future<bool> playCard(int i, [UnoCardColor? chosenWildcardColor]);
  Future<bool> snitchUno(UnoPlayerId player);
  Future<bool> changeName(String name);
  Future<bool> sayUno();
  Future<void> quit();
}

abstract class UnoServer {
  @protected
  UnoStateMachine get stateMachine;
  Future<GameParameters> getParameters();
  Future<UnoPlayerId> addPlayer(String name);
  Future<void> addBot(UnoPlayerId requestingPlayer);
  Future<UnoClientState> currentState(UnoPlayerId player);
  Stream<UnoClientState> state(UnoPlayerId player);
  Future<bool> sendClientEvent(UnoPlayerId player, UnoEvent e);
  Future<void> startGame(UnoPlayerId requestingPlayer);
  Future<void> removePlayer(UnoPlayerId requestingPlayer, UnoPlayerId player);
}
