import 'dart:async';

import 'package:collection/collection.dart';
import 'package:kalil_adt_annotation/kalil_adt_annotation.dart';
import 'package:kalil_utils/utils.dart' hide Tuple;
import 'dart:collection';
import 'data.dart';
import 'package:meta/meta.dart';

part 'state_machine.g.dart';

abstract class UnoStateMachine {
  UnoState get currentState;
  GameParameters get parameters;
  set currentState(UnoState state);
  Stream<UnoState> get state;
  Future<bool> dispatch(UnoEvent event);
}

List<T> twice<T>(T value) => [value, value];
T next<T>(T value, List<T> values) {
  final i = values.indexOf(value);
  return values[(i + 1) % values.length];
}

T previous<T>(T value, List<T> values) {
  final i = values.indexOf(value);
  return values[(i - 1) % values.length];
}

T nextOrPrevious<T>(T value, List<T> values, UnoDirection direction) {
  switch (direction) {
    case UnoDirection.clockwise:
      return next(value, values);
    case UnoDirection.counterClockwise:
      return previous(value, values);
  }
}

@data(
  #PlayersPlayedCardsAndCardStack,
  [],
  Tuple([
    T(#PlayerStates),
    T(#UnoCards),
    T(#UnoCards),
  ]),
  deriveFromJson: true,
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
    // If the card stack is empty and there is only one played card, we cannot
    // draw any cards.
    if (state.e2.isEmpty && state.e1.length <= 1) {
      return state;
    }
    final newCardStack = UnoCards.of(state.e2);
    final newPlayers = PlayerStates.of(state.e0);
    final card = newCardStack.removeLast();
    var playedCards = state.e1;
    if (newCardStack.isEmpty) {
      final lastCard = playedCards.last;
      final oldPlayedCards = playedCards.take(playedCards.length - 2).toList();
      oldPlayedCards.shuffle();
      newCardStack.addAll(oldPlayedCards);
      playedCards = UnoCards()..add(lastCard);
    }
    final oldPlayer = newPlayers[player]!;
    final newPlayer = oldPlayer.copyWith(
      cards: (UnoCardList.of(oldPlayer.cards)..add(card)).just,
      didUno: false.just,
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
  final newPlayers = PlayerStates.of(players);
  final oldPlayer = newPlayers[player]!;
  final newPlayer = oldPlayer.copyWith(
    lastPlayTime: DateTime.now().just,
  );
  newPlayers[player] = newPlayer;
  return newPlayers;
}

T identity<T>(T value) => value;

bool isWildcard(UnoCard card) => card.visitC(
      defaultCard: (_, __) => false,
      reverseCard: (_) => false,
      blockCard: (_) => false,
      plusTwoCard: (_) => false,
      plusFourCard: () => true,
      rainbowCard: () => true,
    );

UnoCardColor cardColor(UnoCard card, [UnoCardColor? onWild]) {
  if (isWildcard(card)) {
    return onWild!;
  }
  return card.visitC(
    defaultCard: (color, __) => color,
    reverseCard: identity,
    blockCard: identity,
    plusTwoCard: identity,
    plusFourCard: unreachable,
    rainbowCard: unreachable,
  );
}

enum PlayStateModification { none, blockPlayer, reverseDirection }

typedef MaybeNextState = Maybe<UnoState>;

@override
Future<MaybeNextState> reduce(
  UnoState state,
  UnoEvent event,
  GameParameters parameters,
) async {
  MaybeNextState changePlayerName(UnoPlayerId id, String name) {
    final oldPlayer = state.players[id];
    if (oldPlayer == null) {
      return None();
    }
    final newPlayers = PlayerStates.of(state.players);
    newPlayers[id] = oldPlayer.copyWith(name: name.just);
    return state.copyWith(players: newPlayers.just).just;
  }

  UnoPlayState skipPlayer(UnoPlaying playState) => playState.copyWith(
        playStartTime: DateTime.now().just,
        currentPlayer: nextOrPrevious(
          playState.currentPlayer,
          state.players.keys.toList(),
          playState.direction,
        ).just,
        direction: playState.direction.just,
        stackingPluses: PlusTwosOrPlusFours().just,
      );

  MaybeNextState removePlayer(UnoPlayerId id) {
    final removedPlayer = state.players[id];
    if (removedPlayer == null) {
      return None();
    }
    final newPlayers = PlayerStates.of(state.players);
    newPlayers.remove(id);
    final newCardStack = UnoCards.of(state.cardStack);
    newCardStack.addAll(removedPlayer.cards);
    return state
        .copyWith(
          players: newPlayers.just,
          cardStack: newCardStack.just,
          play: state.play
              .visit(
                unoPlaying: (playState) {
                  if (playState.currentPlayer != id) {
                    return playState;
                  }
                  return skipPlayer(playState);
                },
                unoWaitingStart: identity,
                unoFinished: identity,
              )
              .just,
        )
        .just;
  }

  UnoPlaying continuePlaying(
    UnoPlaying playState,
    PlayStateModification modification,
    PlusTwosOrPlusFours stackingPluses,
  ) {
    final direction = modification == PlayStateModification.reverseDirection
        ? playState.direction.reverse()
        : playState.direction;
    var nextPlayer = nextOrPrevious(
      playState.currentPlayer,
      state.players.keys.toList(),
      direction,
    );
    if (modification == PlayStateModification.blockPlayer) {
      nextPlayer = nextOrPrevious(
        nextPlayer,
        state.players.keys.toList(),
        direction,
      );
    }
    return UnoPlaying.named(
      startTime: playState.startTime,
      playStartTime: DateTime.now(),
      playRemainingDuration: parameters.playDuration,
      currentPlayer: nextPlayer,
      direction: playState.direction,
      stackingPluses: stackingPluses,
    );
  }

  PlayerStates modifyPlayerState(
    PlayerStates state,
    UnoPlayerState playerState,
  ) {
    final newPlayers = PlayerStates.of(state);
    newPlayers[playerState.id] = playerState;
    return newPlayers;
  }

  TupleN2<PlayerStates, UnoCards> playCard(
    PlayerStates playerStates,
    UnoCards playedCards,
    UnoPlayerId id,
    int cardIndex,
  ) {
    final oldPlayer = state.players[id]!;
    if (cardIndex >= oldPlayer.cards.length) {
      return Tuple2(playerStates, playedCards);
    }
    final newCards = UnoCardList.of(oldPlayer.cards);
    final card = newCards.removeAt(cardIndex);
    final newPlayer = oldPlayer.copyWith(
      cards: newCards.just,
      lastPlayTime: DateTime.now().just,
    );
    final newPlayedCards = UnoCards.of(playedCards);
    newPlayedCards.add(card);
    return Tuple2(
      modifyPlayerState(playerStates, newPlayer),
      newPlayedCards,
    );
  }

  PlusTwosOrPlusFours maybeAddStackingPlus(
    PlusTwosOrPlusFours state,
    UnoCard card,
  ) {
    final isNotPlusTwoOrPlusFour = card.visit(
      defaultCard: (_) => true,
      reverseCard: (_) => true,
      blockCard: (_) => true,
      plusTwoCard: (_) => false,
      plusFourCard: (_) => false,
      rainbowCard: (_) => true,
    );
    if (isNotPlusTwoOrPlusFour) {
      return state;
    }
    final plusTwoOrPlusFour = card.visit(
      defaultCard: unreachable,
      reverseCard: unreachable,
      blockCard: unreachable,
      plusTwoCard: AnPlusTwo.new,
      plusFourCard: AnPlusFour.new,
      rainbowCard: unreachable,
    );
    final newStackingPluses = PlusTwosOrPlusFours.of(state);
    newStackingPluses.add(plusTwoOrPlusFour);
    return newStackingPluses;
  }

  return state.play.visit(
    unoPlaying: (playState) => event.visit(
      startGame: () => None(),
      playCard: (i, chosenWildcardColor) {
        final oldPlayer = state.players[playState.currentPlayer]!;
        if (i >= oldPlayer.cards.length) {
          return None();
        }
        final card = oldPlayer.cards[i];
        if (isWildcard(card) && chosenWildcardColor == null) {
          return None();
        }

        if (playState.stackingPluses.isNotEmpty) {
          final lastPlus = playState.stackingPluses.last;
          final canStack = !card.visit(
            defaultCard: (_) => false,
            reverseCard: (_) => false,
            blockCard: (_) => false,
            plusTwoCard: (_) => lastPlus.visit(
              anPlusTwo: (_) =>
                  parameters.rules.contains(UnoRule.plusTwoStacksPlusTwo),
              anPlusFour: (_) => false,
            ),
            plusFourCard: (_) => lastPlus.visit(
              anPlusTwo: (_) =>
                  parameters.rules.contains(UnoRule.plusFourStacksPlusTwo),
              anPlusFour: (_) =>
                  parameters.rules.contains(UnoRule.plusFourStacksPlusFour),
            ),
            rainbowCard: (_) => false,
          );
          if (!canStack) {
            return None();
          }
          final newPlayersAndPlayedCards = playCard(
            state.players,
            state.playedCards,
            playState.currentPlayer,
            i,
          );
          final newStackingPluses = maybeAddStackingPlus(
            playState.stackingPluses,
            card,
          );
          final newColor = cardColor(card, chosenWildcardColor);
          return UnoState.named(
            players: newPlayersAndPlayedCards.e0,
            playedCards: newPlayersAndPlayedCards.e1,
            cardStack: state.cardStack,
            currentColor: newColor,
            play: continuePlaying(
              playState,
              PlayStateModification.none,
              newStackingPluses,
            ),
          ).just;
        }
        final lastCard = state.playedCards.last;
        final canPlay = card.visitC(
          defaultCard: (color, number) =>
              color == state.currentColor ||
              lastCard is DefaultCard && lastCard.number == number,
          reverseCard: (color) =>
              color == state.currentColor || lastCard is ReverseCard,
          blockCard: (color) =>
              color == state.currentColor || lastCard is BlockCard,
          plusTwoCard: (color) =>
              color == state.currentColor || lastCard is PlusTwoCard,
          plusFourCard: () => true,
          rainbowCard: () => true,
        );
        if (!canPlay) {
          return None();
        }

        final newStackingPluses =
            maybeAddStackingPlus(playState.stackingPluses, card);
        final newColor = cardColor(card, chosenWildcardColor);
        final playStateModification = card.visit(
          defaultCard: (_) => PlayStateModification.none,
          reverseCard: (_) => PlayStateModification.reverseDirection,
          blockCard: (_) => PlayStateModification.blockPlayer,
          plusTwoCard: (_) => PlayStateModification.none,
          plusFourCard: (_) => PlayStateModification.none,
          rainbowCard: (_) => PlayStateModification.none,
        );

        final newPlayersAndPlayedCards = playCard(
          state.players,
          state.playedCards,
          playState.currentPlayer,
          i,
        );

        return UnoState(
          newPlayersAndPlayedCards.e0,
          newPlayersAndPlayedCards.e1,
          state.cardStack,
          newColor,
          continuePlaying(
            playState,
            playStateModification,
            newStackingPluses,
          ),
        ).just;
      },
      sayUno: () {
        final oldPlayer = state.players[playState.currentPlayer]!;
        final newPlayer = oldPlayer.copyWith(didUno: true.just);
        final newPlayers = modifyPlayerState(state.players, newPlayer);

        return state.copyWith(players: newPlayers.just).just;
      },
      addPlayer: (_, __) => None(),
      changePlayerName: changePlayerName,
      removePlayer: removePlayer,
      timePassed: () {
        final now = DateTime.now();
        final durationSincePlayStart = now.difference(playState.playStartTime);
        if (durationSincePlayStart < parameters.playDuration) {
          final newPlayState = playState.copyWith(
            playRemainingDuration:
                (parameters.playDuration - durationSincePlayStart).just,
          );
          return state.copyWith(play: newPlayState.just).just;
        }
        final eatCount = playState.stackingPluses.isEmpty
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
          eatCount,
        );
        final newPlayState = continuePlaying(
          playState,
          PlayStateModification.none,
          PlusTwosOrPlusFours(),
        );
        return UnoState.named(
          players: updatePlayerLastPlay(
            eatenCardState.e0,
            playState.currentPlayer,
          ),
          playedCards: eatenCardState.e1,
          cardStack: eatenCardState.e2,
          currentColor: state.currentColor,
          play: newPlayState,
        ).just;
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
        return UnoState.named(
          players: updatePlayerLastPlay(
            eatenCardState.e0,
            playState.currentPlayer,
          ),
          playedCards: eatenCardState.e1,
          cardStack: eatenCardState.e2,
          currentColor: state.currentColor,
          play: skipPlayer(playState),
        ).just;
      },
      playerSnitchedUno: (player) {
        var playerState = state.players[player];
        if (playerState == null) {
          return None();
        }
        final now = DateTime.now();
        final timeSinceLastPlay = now.difference(playerState.lastPlayTime);
        if (timeSinceLastPlay > parameters.unoSnitchTime) {
          return None();
        }
        if (playerState.didUno) {
          return None();
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
        return UnoState.named(
          players: eatenCardState.e0,
          playedCards: eatenCardState.e1,
          cardStack: eatenCardState.e2,
          currentColor: state.currentColor,
          play: playState,
        ).just;
      },
    ),
    unoWaitingStart: (_) => event.visit(
      startGame: () {
        if (state.players.isEmpty) {
          return None();
        }
        return state
            .copyWith(
              play: Maybe<UnoPlayState>.just(
                UnoPlaying(
                  DateTime.now(),
                  DateTime.now(),
                  Duration(seconds: 30),
                  state.players.keys.first,
                  UnoDirection.clockwise,
                  PlusTwosOrPlusFours(),
                ),
              ),
            )
            .just;
      },
      playCard: (_, __) => None(),
      sayUno: () => None(),
      addPlayer: (id, name) {
        final newCardStack = UnoCards.of(state.cardStack);
        final cards = UnoCardList.of(newCardStack.take(parameters.cardsInHand));
        final newPlayer = UnoPlayerState.named(
          id: id,
          name: name,
          cards: cards,
          lastPlayTime: DateTime.now(),
          didUno: false,
        );
        final newPlayers = modifyPlayerState(state.players, newPlayer);
        return state.copyWith(players: newPlayers.just).just;
      },
      changePlayerName: changePlayerName,
      removePlayer: removePlayer,
      timePassed: () => None(),
      playerDrewCard: () => None(),
      playerSnitchedUno: (_) => None(),
    ),
    unoFinished: (_) => event.visit(
      startGame: () => None(),
      playCard: (_, __) => None(),
      sayUno: () => None(),
      addPlayer: (_, __) => None(),
      changePlayerName: changePlayerName,
      removePlayer: removePlayer,
      timePassed: () => None(),
      playerDrewCard: () => None(),
      playerSnitchedUno: (_) => None(),
    ),
  );
}

@data(
  #GameParameters,
  [],
  Record(
    {
      #cardsInHand: T(#int),
      #playDuration: T(#Duration),
      #unoSnitchTime: T(#Duration),
      #rules: T(#Set, args: [T(#UnoRule)]),
    },
  ),
)
const Type _GameParameters = GameParameters;

class ActualUnoStateMachine extends UnoStateMachine {
  final List<StreamController<UnoState>> _listeners = [];
  final GameParameters parameters;

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
    //...Iterable.generate(4).map((_) => PlusFourCard()),
    //...Iterable.generate(4).map((_) => RainbowCard())
  ];

  UnoState _currentState = () {
    final cards = UnoCardList.of(unoCards)..shuffle();
    // not wild
    final cardI = cards.indexWhere((c) => c is DefaultCard);
    final card = cards.removeAt(cardI);
    return UnoState.named(
      players: {},
      playedCards: UnoCards()..add(card),
      cardStack: UnoCards.of(cards),
      currentColor: cardColor(card),
      play: UnoWaitingStart(),
    );
  }();

  ActualUnoStateMachine(
    this.parameters,
  );

  @override
  UnoState get currentState => _currentState;

  @override
  set currentState(UnoState nextState) {
    if (_currentState == nextState) {
      return;
    }
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

  @override
  Future<bool> dispatch(UnoEvent event) async {
    final s = await reduce(currentState, event, parameters);
    s.visit(
      just: (state) => currentState = state,
      none: () {},
    );
    return s is Just;
  }
}
