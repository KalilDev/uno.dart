import 'dart:async';

import 'package:collection/collection.dart';
import 'package:kalil_adt_annotation/kalil_adt_annotation.dart';
import 'package:kalil_utils/utils.dart' hide Tuple;
import 'dart:collection';
part 'uno.g.dart';

enum UnoCardColor {
  green,
  blue,
  yellow,
  red,
}

@data(
  #UnoCard,
  [],
  Union(
    {
      #DefaultCard: {#color: T(#UnoCardColor), #number: T(#int)},
      #ReverseCard: {#color: T(#UnoCardColor)},
      #BlockCard: {#color: T(#UnoCardColor)},
      #PlusTwoCard: {#color: T(#UnoCardColor)},
      #PlusFourCard: {},
      #RainbowCard: {},
    },
  ),
)
const Type _UnoCard = UnoCard;

@data(
  #UnoPlayerId,
  [],
  Opaque(T(#String)),
)
const Type _UnoPlayerId = UnoPlayerId;

@data(
  #UnoState,
  [],
  Record(
    {
      #players: T(#Map, args: [T(#UnoPlayerId), T(#UnoPlayerState)]),
      #playedCards: T(#Queue, args: [T(#UnoCard)]),
      #cardStack: T(#Queue, args: [T(#UnoCard)]),
      #play: T(#UnoPlayState),
    },
  ),
)
const Type _UnoState = UnoState;

@data(
  #UnoPlayerState,
  [],
  Record(
    {
      #id: T(#UnoPlayerId),
      #name: T(#String),
      #cards: T(#List, args: [T(#UnoCard)]),
      #lastPlayTime: T(#DateTime),
      #didUno: T(#bool),
    },
  ),
)
const Type _UnoPlayerState = UnoPlayerState;

enum UnoDirection { clockwise, counterClockwise }

@data(
  #AnPlusTwoOrAnPlusFour,
  [],
  Union(
    {
      #AnPlusTwo: {#card: T(#PlusTwoCard)},
      #AnPlusFour: {#card: T(#PlusFourCard)},
    },
  ),
)
const Type _AnPlusTwoOrAnPlusFour = AnPlusTwoOrAnPlusFour;

@data(
  #UnoPlayState,
  [],
  Union({
    #UnoPlaying: {
      #startTime: T(#DateTime),
      #playStartTime: T(#DateTime),
      #playRemainingDuration: T(#Duration),
      #currentPlayer: T(#UnoPlayerId),
      #direction: T(#UnoDirection),
      #stackingPluses: T(#Queue, args: [T(#AnPlusTwoOrAnPlusFour)]),
    },
    #UnoWaitingStart: {},
    #UnoFinished: {#winner: T(#UnoPlayerId), #duration: T(#Duration)},
  }),
)
const Type _UnoPlayState = UnoPlayState;

@data(
  #UnoEvent,
  [],
  Union(
    {
      #StartGame: {},
      #PlayCard: {
        #cardIndex: T(#int),
        #chosenWildcardColor: T.n(#UnoCardColor),
      },
      #SayUno: {},
      #AddPlayer: {#id: T(#UnoPlayerId), #name: T(#String)},
      #ChangePlayerName: {#id: T(#UnoPlayerId), #name: T(#String)},
      #RemovePlayer: {#id: T(#UnoPlayerId)},
      #TimePassed: {},
      #PlayerDrewCard: {},
      #PlayerSnitchedUno: {#player: T(#UnoPlayerId)}
    },
  ),
)
const Type _UnoEvent = UnoEvent;

abstract class UnoStateMachine {
  UnoState get currentState;
  set currentState(UnoState state);
  Stream<UnoState> get state;
  void dispatch(UnoEvent event);
  UnoState reduce(UnoState state, UnoEvent event);
}

List<T> twice<T>(T value) => [value, value];
T next<T>(T value, Iterable<T> values) {
  final it = values.iterator;
  while (it.moveNext()) {
    if (it.current != value) {
      continue;
    }
    if (it.moveNext()) {
      return it.current;
    }
    return value;
  }
  throw Exception("Value not in values");
}

T previous<T>(T value, Iterable<T> values) {
  final it = values.iterator;
  late T last;
  var hasLast = false;
  while (it.moveNext()) {
    if (it.current == value) {
      return hasLast ? last : value;
    }
    hasLast = true;
    last = it.current;
  }
  throw Exception("Value not in values");
}

T nextOrPrevious<T>(T value, Iterable<T> values, UnoDirection direction) {
  switch (direction) {
    case UnoDirection.clockwise:
      return next(value, values);
    case UnoDirection.counterClockwise:
      return previous(value, values);
  }
}

enum UnoRule { plusFourStacksPlusTwo, plusFourStacksPlusFour }

@data(
  #PlayersPlayedCardsAndCardStack,
  [],
  Tuple([
    T(#Map, args: [T(#UnoPlayerId), T(#UnoPlayerState)]),
    T(#Queue, args: [T(#UnoCard)]),
    T(#Queue, args: [T(#UnoCard)]),
  ]),
)
const Type _PlayersPlayedCardsAndCardStack = PlayersPlayedCardsAndCardStack;

PlayersPlayedCardsAndCardStack makePlayerEatCards(
  PlayersPlayedCardsAndCardStack state,
  UnoPlayerId player,
  int count,
) {
  if (count == 0) {
    return state;
  }
  PlayersPlayedCardsAndCardStack drawSingle(
    PlayersPlayedCardsAndCardStack state,
  ) {
    final newCardStack = Queue.of(state.e2);
    final newPlayers = Map.of(state.e0);
    final card = newCardStack.removeLast();
    var playedCards = state.e1;
    if (newCardStack.isEmpty) {
      final lastCard = playedCards.last;
      final oldPlayedCards = playedCards.take(playedCards.length - 2).toList();
      oldPlayedCards.shuffle();
      newCardStack.addAll(oldPlayedCards);
      playedCards = Queue()..add(lastCard);
    }
    final oldPlayer = newPlayers[player]!;
    final newPlayer = UnoPlayerState(
      player,
      oldPlayer.name,
      oldPlayer.cards.toList()..remove(card),
      oldPlayer.lastPlayTime,
      false,
    );
    newPlayers[player] = newPlayer;
    return PlayersPlayedCardsAndCardStack(
      newPlayers,
      playedCards,
      newCardStack,
    );
  }

  return Iterable.generate(count).fold(
    state,
    (currentState, i) => drawSingle(currentState),
  );
}

Map<UnoPlayerId, UnoPlayerState> updatePlayerLastPlay(
  Map<UnoPlayerId, UnoPlayerState> players,
  UnoPlayerId player,
) {
  final newPlayers = Map.of(players);
  final oldPlayer = newPlayers[player]!;
  final newPlayer = UnoPlayerState(
    player,
    oldPlayer.name,
    oldPlayer.cards,
    DateTime.now(),
    oldPlayer.didUno,
  );
  newPlayers[player] = newPlayer;
  return newPlayers;
}

T identity<T>(T value) => value;

class ActualUnoStateMachine extends UnoStateMachine {
  final List<StreamController<UnoState>> _listeners = [];
  final int cardsInHand;
  final Duration playDuration;
  final Duration unoSnitchTime;
  final Set<UnoRule> rules;

  static final List<UnoCard> unoCards = [
    ...Iterable.generate(10)
        .bind((number) => number == 0 ? [number] : twice(number))
        .bind((number) => UnoCardColor.values.map(
              (color) => DefaultCard(
                color,
                number,
              ),
            )),
    ...UnoCardColor.values.bind(twice).map(ReverseCard.new),
    ...UnoCardColor.values.bind(twice).map(BlockCard.new),
    ...UnoCardColor.values.bind(twice).map(PlusTwoCard.new),
    ...Iterable.generate(4).map((_) => PlusFourCard()),
    ...Iterable.generate(4).map((_) => RainbowCard())
  ];

  UnoState _currentState = UnoState(
    {},
    Queue(),
    Queue.of(unoCards.toList()..shuffle()),
    UnoWaitingStart(),
  );

  @override
  UnoState get currentState => _currentState;

  @override
  set currentState(UnoState nextState) {
    _currentState = nextState;
    for (final listener in _listeners) {
      listener.add(nextState);
    }
  }

  Stream<UnoState> get state {
    final controller = StreamController<UnoState>();
    controller.onListen = () => _listeners.add(controller);
    controller.onCancel = () => _listeners.remove(controller);
    controller.add(currentState);
    return controller.stream;
  }

  void dispatch(UnoEvent event) => currentState = reduce(currentState, event);

  UnoState reduce(UnoState state, UnoEvent event) {
    UnoState changePlayerName(UnoPlayerId id, String name) {
      final oldPlayer = state.players[id];
      if (oldPlayer == null) {
        return state;
      }
      final newPlayers = Map.of(state.players);
      return UnoState(
        newPlayers
          ..[id] = UnoPlayerState(
            id,
            name,
            oldPlayer.cards,
            oldPlayer.lastPlayTime,
            oldPlayer.didUno,
          ),
        state.playedCards,
        state.cardStack,
        state.play,
      );
    }

    UnoPlayState skipPlayer(UnoPlaying playState) => UnoPlaying(
          playState.startTime,
          DateTime.now(),
          playDuration,
          nextOrPrevious(
            playState.currentPlayer,
            state.players.keys,
            playState.direction,
          ),
          playState.direction,
          Queue(),
        );

    UnoState removePlayer(UnoPlayerId id) {
      final removedPlayer = state.players[id];
      if (removedPlayer == null) {
        return state;
      }
      final newPlayers = Map.of(state.players);
      final newCardStack = Queue.of(state.cardStack);
      newPlayers.remove(id);
      return UnoState(
        newPlayers,
        state.playedCards,
        newCardStack..addAll(removedPlayer.cards),
        state.play.visit(
          unoPlaying: (playState) {
            if (playState.currentPlayer != id) {
              return playState;
            }
            return skipPlayer(playState);
          },
          unoWaitingStart: identity,
          unoFinished: identity,
        ),
      );
    }

    return state.play.visit(
      unoPlaying: (playState) => event.visit(
        startGame: () => state,
        playCard: (i, chosenWildcardColor) {
          final oldPlayer = state.players[playState.currentPlayer]!;
          if (i >= oldPlayer.cards.length) {
            return state;
          }
          final card = oldPlayer.cards[i];
          final isWildcard = card.visit(
            defaultCard: (_, __) => false,
            reverseCard: (_) => false,
            blockCard: (_) => false,
            plusTwoCard: (_) => false,
            plusFourCard: () => true,
            rainbowCard: () => true,
          );
          if (isWildcard && chosenWildcardColor == null) {
            return state;
          }
          final topOfStack = state.playedCards.last;
          final canPlay = topOfStack.visit(
            defaultCard: defaultCard,
            reverseCard: reverseCard,
            blockCard: blockCard,
            plusTwoCard: plusTwoCard,
            plusFourCard: plusFourCard,
            rainbowCard: rainbowCard,
          );
        },
        sayUno: () {
          final oldPlayer = state.players[playState.currentPlayer]!;
          final newPlayers = Map.of(state.players);
          final newPlayer = UnoPlayerState(
            oldPlayer.id,
            oldPlayer.name,
            oldPlayer.cards,
            DateTime.now(),
            true,
          );
          newPlayers[playState.currentPlayer] = newPlayer;

          final newPlayState = UnoPlaying(
            playState.startTime,
            DateTime.now(),
            playDuration,
            nextOrPrevious(
              playState.currentPlayer,
              state.players.keys,
              playState.direction,
            ),
            playState.direction,
            Queue(),
          );
          return UnoState(
            newPlayers,
            state.playedCards,
            state.cardStack,
            newPlayState,
          );
        },
        addPlayer: (_, __) => state,
        changePlayerName: changePlayerName,
        removePlayer: removePlayer,
        timePassed: () {
          final now = DateTime.now();
          final durationSincePlayStart =
              now.difference(playState.playStartTime);
          if (durationSincePlayStart < playDuration) {
            final newPlayState = UnoPlaying(
              playState.startTime,
              DateTime.now(),
              playDuration - durationSincePlayStart,
              playState.currentPlayer,
              playState.direction,
              playState.stackingPluses,
            );
            return UnoState(
              state.players,
              state.playedCards,
              state.cardStack,
              newPlayState,
            );
          }
          final eatCount = playState.stackingPluses.isEmpty
              ? 0
              : playState.stackingPluses.fold(
                  0,
                  (acc, card) =>
                      acc +
                      card.visit(
                        anPlusTwo: (_) => 2,
                        anPlusFour: (_) => 4,
                      ),
                );
          final eatenCardState = makePlayerEatCards(
            PlayersPlayedCardsAndCardStack(
              state.players,
              state.playedCards,
              state.cardStack,
            ),
            playState.currentPlayer,
            eatCount,
          );
          final newPlayState = UnoPlaying(
            playState.startTime,
            DateTime.now(),
            playDuration,
            nextOrPrevious(
              playState.currentPlayer,
              state.players.keys,
              playState.direction,
            ),
            playState.direction,
            Queue(),
          );
          return UnoState(
            updatePlayerLastPlay(eatenCardState.e0, playState.currentPlayer),
            eatenCardState.e1,
            eatenCardState.e2,
            newPlayState,
          );
        },
        playerDrewCard: () {
          final count = playState.stackingPluses.isEmpty
              ? 1
              : playState.stackingPluses.fold(
                  0,
                  (acc, card) =>
                      acc +
                      card.visit(
                        anPlusTwo: (_) => 2,
                        anPlusFour: (_) => 4,
                      ),
                );
          final eatenCardState = makePlayerEatCards(
            PlayersPlayedCardsAndCardStack(
              state.players,
              state.playedCards,
              state.cardStack,
            ),
            playState.currentPlayer,
            count,
          );
          return UnoState(
            updatePlayerLastPlay(eatenCardState.e0, playState.currentPlayer),
            eatenCardState.e1,
            eatenCardState.e2,
            skipPlayer(playState),
          );
        },
        playerSnitchedUno: (player) {
          var playerState = state.players[player];
          if (playerState == null) {
            return state;
          }
          final now = DateTime.now();
          final timeSinceLastPlay = now.difference(playerState.lastPlayTime);
          if (timeSinceLastPlay > unoSnitchTime) {
            return state;
          }
          if (playerState.didUno) {
            return state;
          }
          final eatenCardState = makePlayerEatCards(
            PlayersPlayedCardsAndCardStack(
              state.players,
              state.playedCards,
              state.cardStack,
            ),
            player,
            1,
          );
          return UnoState(
            eatenCardState.e0,
            eatenCardState.e1,
            eatenCardState.e2,
            playState,
          );
        },
      ),
      unoWaitingStart: (_) => event.visit(
        startGame: () {
          if (state.players.isEmpty) {
            return state;
          }
          return UnoState(
            state.players,
            state.playedCards,
            state.cardStack,
            UnoPlaying(
              DateTime.now(),
              DateTime.now(),
              Duration(seconds: 30),
              state.players.keys.first,
              UnoDirection.clockwise,
              Queue(),
            ),
          );
        },
        playCard: (_, __) => state,
        sayUno: () => state,
        addPlayer: (id, name) {
          final newPlayers = Map.of(state.players);
          final newCardStack = Queue.of(state.cardStack);
          final cards = newCardStack.take(cardsInHand).toList();
          return UnoState(
            newPlayers
              ..[id] = UnoPlayerState(
                id,
                name,
                cards,
                DateTime.now(),
                false,
              ),
            state.playedCards,
            state.cardStack,
            state.play,
          );
        },
        changePlayerName: changePlayerName,
        removePlayer: removePlayer,
        timePassed: () => state,
        playerDrewCard: () => state,
        playerSnitchedUno: (_) => state,
      ),
      unoFinished: (_) => event.visit(
        startGame: () => state,
        playCard: (_, __) => state,
        sayUno: () => state,
        addPlayer: (_, __) => state,
        changePlayerName: changePlayerName,
        removePlayer: removePlayer,
        timePassed: () => state,
        playerDrewCard: () => state,
        playerSnitchedUno: (_) => state,
      ),
    );
  }
}
