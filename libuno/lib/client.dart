import 'dart:async';

import 'package:collection/collection.dart';
import 'package:kalil_adt_annotation/kalil_adt_annotation.dart';
import 'package:kalil_utils/utils.dart' hide Tuple;
import 'package:libuno/server.dart';
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
