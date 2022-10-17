// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uno.dart';

// **************************************************************************
// AdtGenerator
// **************************************************************************

abstract class UnoCard implements SumType {
  const UnoCard._();
  const factory UnoCard.defaultCard(UnoCardColor color, int number) =
      DefaultCard;
  const factory UnoCard.reverseCard(UnoCardColor color) = ReverseCard;
  const factory UnoCard.blockCard(UnoCardColor color) = BlockCard;
  const factory UnoCard.plusTwoCard(UnoCardColor color) = PlusTwoCard;
  const factory UnoCard.plusFourCard() = PlusFourCard;
  const factory UnoCard.rainbowCard() = RainbowCard;

  @override
  SumRuntimeType get runtimeType => SumRuntimeType([
        DefaultCard,
        ReverseCard,
        BlockCard,
        PlusTwoCard,
        PlusFourCard,
        RainbowCard
      ]);

  R visit<R extends Object?>(
      {required R Function(DefaultCard) defaultCard,
      required R Function(ReverseCard) reverseCard,
      required R Function(BlockCard) blockCard,
      required R Function(PlusTwoCard) plusTwoCard,
      required R Function(PlusFourCard) plusFourCard,
      required R Function(RainbowCard) rainbowCard});
  R visitC<R extends Object?>(
      {required R Function(UnoCardColor color, int number) defaultCard,
      required R Function(UnoCardColor color) reverseCard,
      required R Function(UnoCardColor color) blockCard,
      required R Function(UnoCardColor color) plusTwoCard,
      required R Function() plusFourCard,
      required R Function() rainbowCard});

  @override
  int get hashCode => throw UnimplementedError(
      'Each case has its own implementation of hashCode');
  bool operator ==(other) =>
      throw UnimplementedError('Each case has its own implementation of ==');

  String toString() => throw UnimplementedError(
      'Each case has its own implementation of toString');
}

class DefaultCard extends UnoCard {
  final UnoCardColor color;
  final int number;

  const DefaultCard(this.color, this.number) : super._();

  const DefaultCard.named({required this.color, required this.number})
      : super._();

  @override
  int get hashCode => Object.hash((DefaultCard), color, number);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is DefaultCard &&
          true &&
          this.color == other.color &&
          this.number == other.number);

  @override
  String toString() => "DefaultCard { $color, $number }";

  DefaultCard copyWith(
          {Maybe<UnoCardColor> color = const Maybe.none(),
          Maybe<int> number = const Maybe.none()}) =>
      DefaultCard(color.valueOr(this.color), number.valueOr(this.number));

  @override
  R visit<R extends Object?>(
          {required R Function(DefaultCard) defaultCard,
          required R Function(ReverseCard) reverseCard,
          required R Function(BlockCard) blockCard,
          required R Function(PlusTwoCard) plusTwoCard,
          required R Function(PlusFourCard) plusFourCard,
          required R Function(RainbowCard) rainbowCard}) =>
      defaultCard(this);

  @override
  R visitC<R extends Object?>(
          {required R Function(UnoCardColor color, int number) defaultCard,
          required R Function(UnoCardColor color) reverseCard,
          required R Function(UnoCardColor color) blockCard,
          required R Function(UnoCardColor color) plusTwoCard,
          required R Function() plusFourCard,
          required R Function() rainbowCard}) =>
      defaultCard(this.color, this.number);
}

class ReverseCard extends UnoCard {
  final UnoCardColor color;

  const ReverseCard(this.color) : super._();

  const ReverseCard.named({required this.color}) : super._();

  @override
  int get hashCode => Object.hash((ReverseCard), color);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is ReverseCard && true && this.color == other.color);

  @override
  String toString() => "ReverseCard { $color }";

  ReverseCard copyWith({Maybe<UnoCardColor> color = const Maybe.none()}) =>
      ReverseCard(color.valueOr(this.color));

  @override
  R visit<R extends Object?>(
          {required R Function(DefaultCard) defaultCard,
          required R Function(ReverseCard) reverseCard,
          required R Function(BlockCard) blockCard,
          required R Function(PlusTwoCard) plusTwoCard,
          required R Function(PlusFourCard) plusFourCard,
          required R Function(RainbowCard) rainbowCard}) =>
      reverseCard(this);

  @override
  R visitC<R extends Object?>(
          {required R Function(UnoCardColor color, int number) defaultCard,
          required R Function(UnoCardColor color) reverseCard,
          required R Function(UnoCardColor color) blockCard,
          required R Function(UnoCardColor color) plusTwoCard,
          required R Function() plusFourCard,
          required R Function() rainbowCard}) =>
      reverseCard(this.color);
}

class BlockCard extends UnoCard {
  final UnoCardColor color;

  const BlockCard(this.color) : super._();

  const BlockCard.named({required this.color}) : super._();

  @override
  int get hashCode => Object.hash((BlockCard), color);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is BlockCard && true && this.color == other.color);

  @override
  String toString() => "BlockCard { $color }";

  BlockCard copyWith({Maybe<UnoCardColor> color = const Maybe.none()}) =>
      BlockCard(color.valueOr(this.color));

  @override
  R visit<R extends Object?>(
          {required R Function(DefaultCard) defaultCard,
          required R Function(ReverseCard) reverseCard,
          required R Function(BlockCard) blockCard,
          required R Function(PlusTwoCard) plusTwoCard,
          required R Function(PlusFourCard) plusFourCard,
          required R Function(RainbowCard) rainbowCard}) =>
      blockCard(this);

  @override
  R visitC<R extends Object?>(
          {required R Function(UnoCardColor color, int number) defaultCard,
          required R Function(UnoCardColor color) reverseCard,
          required R Function(UnoCardColor color) blockCard,
          required R Function(UnoCardColor color) plusTwoCard,
          required R Function() plusFourCard,
          required R Function() rainbowCard}) =>
      blockCard(this.color);
}

class PlusTwoCard extends UnoCard {
  final UnoCardColor color;

  const PlusTwoCard(this.color) : super._();

  const PlusTwoCard.named({required this.color}) : super._();

  @override
  int get hashCode => Object.hash((PlusTwoCard), color);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is PlusTwoCard && true && this.color == other.color);

  @override
  String toString() => "PlusTwoCard { $color }";

  PlusTwoCard copyWith({Maybe<UnoCardColor> color = const Maybe.none()}) =>
      PlusTwoCard(color.valueOr(this.color));

  @override
  R visit<R extends Object?>(
          {required R Function(DefaultCard) defaultCard,
          required R Function(ReverseCard) reverseCard,
          required R Function(BlockCard) blockCard,
          required R Function(PlusTwoCard) plusTwoCard,
          required R Function(PlusFourCard) plusFourCard,
          required R Function(RainbowCard) rainbowCard}) =>
      plusTwoCard(this);

  @override
  R visitC<R extends Object?>(
          {required R Function(UnoCardColor color, int number) defaultCard,
          required R Function(UnoCardColor color) reverseCard,
          required R Function(UnoCardColor color) blockCard,
          required R Function(UnoCardColor color) plusTwoCard,
          required R Function() plusFourCard,
          required R Function() rainbowCard}) =>
      plusTwoCard(this.color);
}

class PlusFourCard extends UnoCard {
  const PlusFourCard() : super._();

  @override
  int get hashCode => (PlusFourCard).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is PlusFourCard && true);

  @override
  String toString() => "PlusFourCard";

  @override
  R visit<R extends Object?>(
          {required R Function(DefaultCard) defaultCard,
          required R Function(ReverseCard) reverseCard,
          required R Function(BlockCard) blockCard,
          required R Function(PlusTwoCard) plusTwoCard,
          required R Function(PlusFourCard) plusFourCard,
          required R Function(RainbowCard) rainbowCard}) =>
      plusFourCard(this);

  @override
  R visitC<R extends Object?>(
          {required R Function(UnoCardColor color, int number) defaultCard,
          required R Function(UnoCardColor color) reverseCard,
          required R Function(UnoCardColor color) blockCard,
          required R Function(UnoCardColor color) plusTwoCard,
          required R Function() plusFourCard,
          required R Function() rainbowCard}) =>
      plusFourCard();
}

class RainbowCard extends UnoCard {
  const RainbowCard() : super._();

  @override
  int get hashCode => (RainbowCard).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is RainbowCard && true);

  @override
  String toString() => "RainbowCard";

  @override
  R visit<R extends Object?>(
          {required R Function(DefaultCard) defaultCard,
          required R Function(ReverseCard) reverseCard,
          required R Function(BlockCard) blockCard,
          required R Function(PlusTwoCard) plusTwoCard,
          required R Function(PlusFourCard) plusFourCard,
          required R Function(RainbowCard) rainbowCard}) =>
      rainbowCard(this);

  @override
  R visitC<R extends Object?>(
          {required R Function(UnoCardColor color, int number) defaultCard,
          required R Function(UnoCardColor color) reverseCard,
          required R Function(UnoCardColor color) blockCard,
          required R Function(UnoCardColor color) plusTwoCard,
          required R Function() plusFourCard,
          required R Function() rainbowCard}) =>
      rainbowCard();
}

class UnoPlayerId implements ProductType {
  final String _unwrap;

  const UnoPlayerId(this._unwrap);

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([UnoPlayerId]);

  @override
  int get hashCode => Object.hash((UnoPlayerId), _unwrap);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is UnoPlayerId && true && this._unwrap == other._unwrap);

  @override
  String toString() => "UnoPlayerId { $_unwrap }";
}

class UnoState implements ProductType {
  final PlayerStates players;
  final UnoCards playedCards;
  final UnoCards cardStack;
  final UnoCardColor currentColor;
  final UnoPlayState play;

  const UnoState(this.players, this.playedCards, this.cardStack,
      this.currentColor, this.play)
      : super();

  const UnoState.named(
      {required this.players,
      required this.playedCards,
      required this.cardStack,
      required this.currentColor,
      required this.play})
      : super();

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType(
      [PlayerStates, UnoCards, UnoCards, UnoCardColor, UnoPlayState]);

  @override
  int get hashCode => Object.hash(
      (UnoState), players, playedCards, cardStack, currentColor, play);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is UnoState &&
          true &&
          this.players == other.players &&
          this.playedCards == other.playedCards &&
          this.cardStack == other.cardStack &&
          this.currentColor == other.currentColor &&
          this.play == other.play);

  @override
  String toString() =>
      "UnoState { $players, $playedCards, $cardStack, $currentColor, $play }";

  UnoState copyWith(
          {Maybe<PlayerStates> players = const Maybe.none(),
          Maybe<UnoCards> playedCards = const Maybe.none(),
          Maybe<UnoCards> cardStack = const Maybe.none(),
          Maybe<UnoCardColor> currentColor = const Maybe.none(),
          Maybe<UnoPlayState> play = const Maybe.none()}) =>
      UnoState(
          players.valueOr(this.players),
          playedCards.valueOr(this.playedCards),
          cardStack.valueOr(this.cardStack),
          currentColor.valueOr(this.currentColor),
          play.valueOr(this.play));
}

class UnoPlayerState implements ProductType {
  final UnoPlayerId id;
  final String name;
  final UnoCardList cards;
  final DateTime lastPlayTime;
  final bool didUno;

  const UnoPlayerState(
      this.id, this.name, this.cards, this.lastPlayTime, this.didUno)
      : super();

  const UnoPlayerState.named(
      {required this.id,
      required this.name,
      required this.cards,
      required this.lastPlayTime,
      required this.didUno})
      : super();

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([UnoPlayerId, String, UnoCardList, DateTime, bool]);

  @override
  int get hashCode =>
      Object.hash((UnoPlayerState), id, name, cards, lastPlayTime, didUno);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is UnoPlayerState &&
          true &&
          this.id == other.id &&
          this.name == other.name &&
          this.cards == other.cards &&
          this.lastPlayTime == other.lastPlayTime &&
          this.didUno == other.didUno);

  @override
  String toString() =>
      "UnoPlayerState { $id, $name, $cards, $lastPlayTime, $didUno }";

  UnoPlayerState copyWith(
          {Maybe<UnoPlayerId> id = const Maybe.none(),
          Maybe<String> name = const Maybe.none(),
          Maybe<UnoCardList> cards = const Maybe.none(),
          Maybe<DateTime> lastPlayTime = const Maybe.none(),
          Maybe<bool> didUno = const Maybe.none()}) =>
      UnoPlayerState(
          id.valueOr(this.id),
          name.valueOr(this.name),
          cards.valueOr(this.cards),
          lastPlayTime.valueOr(this.lastPlayTime),
          didUno.valueOr(this.didUno));
}

abstract class AnPlusTwoOrAnPlusFour implements SumType {
  const AnPlusTwoOrAnPlusFour._();
  const factory AnPlusTwoOrAnPlusFour.anPlusTwo(PlusTwoCard card) = AnPlusTwo;
  const factory AnPlusTwoOrAnPlusFour.anPlusFour(PlusFourCard card) =
      AnPlusFour;

  @override
  SumRuntimeType get runtimeType => SumRuntimeType([AnPlusTwo, AnPlusFour]);

  R visit<R extends Object?>(
      {required R Function(PlusTwoCard card) anPlusTwo,
      required R Function(PlusFourCard card) anPlusFour});

  @override
  int get hashCode => throw UnimplementedError(
      'Each case has its own implementation of hashCode');
  bool operator ==(other) =>
      throw UnimplementedError('Each case has its own implementation of ==');

  String toString() => throw UnimplementedError(
      'Each case has its own implementation of toString');
}

class AnPlusTwo extends AnPlusTwoOrAnPlusFour {
  final PlusTwoCard card;

  const AnPlusTwo(this.card) : super._();

  const AnPlusTwo.named({required this.card}) : super._();

  @override
  int get hashCode => Object.hash((AnPlusTwo), card);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is AnPlusTwo && true && this.card == other.card);

  @override
  String toString() => "AnPlusTwo { $card }";

  AnPlusTwo copyWith({Maybe<PlusTwoCard> card = const Maybe.none()}) =>
      AnPlusTwo(card.valueOr(this.card));

  @override
  R visit<R extends Object?>(
          {required R Function(PlusTwoCard card) anPlusTwo,
          required R Function(PlusFourCard card) anPlusFour}) =>
      anPlusTwo(this.card);
}

class AnPlusFour extends AnPlusTwoOrAnPlusFour {
  final PlusFourCard card;

  const AnPlusFour(this.card) : super._();

  const AnPlusFour.named({required this.card}) : super._();

  @override
  int get hashCode => Object.hash((AnPlusFour), card);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is AnPlusFour && true && this.card == other.card);

  @override
  String toString() => "AnPlusFour { $card }";

  AnPlusFour copyWith({Maybe<PlusFourCard> card = const Maybe.none()}) =>
      AnPlusFour(card.valueOr(this.card));

  @override
  R visit<R extends Object?>(
          {required R Function(PlusTwoCard card) anPlusTwo,
          required R Function(PlusFourCard card) anPlusFour}) =>
      anPlusFour(this.card);
}

abstract class UnoPlayState implements SumType {
  const UnoPlayState._();
  const factory UnoPlayState.unoPlaying(
      DateTime startTime,
      DateTime playStartTime,
      Duration playRemainingDuration,
      UnoPlayerId currentPlayer,
      UnoDirection direction,
      Queue<AnPlusTwoOrAnPlusFour> stackingPluses) = UnoPlaying;
  const factory UnoPlayState.unoWaitingStart() = UnoWaitingStart;
  const factory UnoPlayState.unoFinished(
      UnoPlayerId winner, Duration duration) = UnoFinished;

  @override
  SumRuntimeType get runtimeType =>
      SumRuntimeType([UnoPlaying, UnoWaitingStart, UnoFinished]);

  R visit<R extends Object?>(
      {required R Function(UnoPlaying) unoPlaying,
      required R Function(UnoWaitingStart) unoWaitingStart,
      required R Function(UnoFinished) unoFinished});

  @override
  int get hashCode => throw UnimplementedError(
      'Each case has its own implementation of hashCode');
  bool operator ==(other) =>
      throw UnimplementedError('Each case has its own implementation of ==');

  String toString() => throw UnimplementedError(
      'Each case has its own implementation of toString');
}

class UnoPlaying extends UnoPlayState {
  final DateTime startTime;
  final DateTime playStartTime;
  final Duration playRemainingDuration;
  final UnoPlayerId currentPlayer;
  final UnoDirection direction;
  final Queue<AnPlusTwoOrAnPlusFour> stackingPluses;

  const UnoPlaying(
      this.startTime,
      this.playStartTime,
      this.playRemainingDuration,
      this.currentPlayer,
      this.direction,
      this.stackingPluses)
      : super._();

  const UnoPlaying.named(
      {required this.startTime,
      required this.playStartTime,
      required this.playRemainingDuration,
      required this.currentPlayer,
      required this.direction,
      required this.stackingPluses})
      : super._();

  @override
  int get hashCode => Object.hash((UnoPlaying), startTime, playStartTime,
      playRemainingDuration, currentPlayer, direction, stackingPluses);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is UnoPlaying &&
          true &&
          this.startTime == other.startTime &&
          this.playStartTime == other.playStartTime &&
          this.playRemainingDuration == other.playRemainingDuration &&
          this.currentPlayer == other.currentPlayer &&
          this.direction == other.direction &&
          this.stackingPluses == other.stackingPluses);

  @override
  String toString() =>
      "UnoPlaying { $startTime, $playStartTime, $playRemainingDuration, $currentPlayer, $direction, $stackingPluses }";

  UnoPlaying copyWith(
          {Maybe<DateTime> startTime = const Maybe.none(),
          Maybe<DateTime> playStartTime = const Maybe.none(),
          Maybe<Duration> playRemainingDuration = const Maybe.none(),
          Maybe<UnoPlayerId> currentPlayer = const Maybe.none(),
          Maybe<UnoDirection> direction = const Maybe.none(),
          Maybe<Queue<AnPlusTwoOrAnPlusFour>> stackingPluses =
              const Maybe.none()}) =>
      UnoPlaying(
          startTime.valueOr(this.startTime),
          playStartTime.valueOr(this.playStartTime),
          playRemainingDuration.valueOr(this.playRemainingDuration),
          currentPlayer.valueOr(this.currentPlayer),
          direction.valueOr(this.direction),
          stackingPluses.valueOr(this.stackingPluses));

  @override
  R visit<R extends Object?>(
          {required R Function(UnoPlaying) unoPlaying,
          required R Function(UnoWaitingStart) unoWaitingStart,
          required R Function(UnoFinished) unoFinished}) =>
      unoPlaying(this);
}

class UnoWaitingStart extends UnoPlayState {
  const UnoWaitingStart() : super._();

  @override
  int get hashCode => (UnoWaitingStart).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is UnoWaitingStart && true);

  @override
  String toString() => "UnoWaitingStart";

  @override
  R visit<R extends Object?>(
          {required R Function(UnoPlaying) unoPlaying,
          required R Function(UnoWaitingStart) unoWaitingStart,
          required R Function(UnoFinished) unoFinished}) =>
      unoWaitingStart(this);
}

class UnoFinished extends UnoPlayState {
  final UnoPlayerId winner;
  final Duration duration;

  const UnoFinished(this.winner, this.duration) : super._();

  const UnoFinished.named({required this.winner, required this.duration})
      : super._();

  @override
  int get hashCode => Object.hash((UnoFinished), winner, duration);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is UnoFinished &&
          true &&
          this.winner == other.winner &&
          this.duration == other.duration);

  @override
  String toString() => "UnoFinished { $winner, $duration }";

  UnoFinished copyWith(
          {Maybe<UnoPlayerId> winner = const Maybe.none(),
          Maybe<Duration> duration = const Maybe.none()}) =>
      UnoFinished(winner.valueOr(this.winner), duration.valueOr(this.duration));

  @override
  R visit<R extends Object?>(
          {required R Function(UnoPlaying) unoPlaying,
          required R Function(UnoWaitingStart) unoWaitingStart,
          required R Function(UnoFinished) unoFinished}) =>
      unoFinished(this);
}

abstract class UnoEvent implements SumType {
  const UnoEvent._();
  const factory UnoEvent.startGame() = StartGame;
  const factory UnoEvent.playCard(
      int cardIndex, UnoCardColor? chosenWildcardColor) = PlayCard;
  const factory UnoEvent.sayUno() = SayUno;
  const factory UnoEvent.addPlayer(UnoPlayerId id, String name) = AddPlayer;
  const factory UnoEvent.changePlayerName(UnoPlayerId id, String name) =
      ChangePlayerName;
  const factory UnoEvent.removePlayer(UnoPlayerId id) = RemovePlayer;
  const factory UnoEvent.timePassed() = TimePassed;
  const factory UnoEvent.playerDrewCard() = PlayerDrewCard;
  const factory UnoEvent.playerSnitchedUno(UnoPlayerId player) =
      PlayerSnitchedUno;

  @override
  SumRuntimeType get runtimeType => SumRuntimeType([
        StartGame,
        PlayCard,
        SayUno,
        AddPlayer,
        ChangePlayerName,
        RemovePlayer,
        TimePassed,
        PlayerDrewCard,
        PlayerSnitchedUno
      ]);

  R visit<R extends Object?>(
      {required R Function() startGame,
      required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
          playCard,
      required R Function() sayUno,
      required R Function(UnoPlayerId id, String name) addPlayer,
      required R Function(UnoPlayerId id, String name) changePlayerName,
      required R Function(UnoPlayerId id) removePlayer,
      required R Function() timePassed,
      required R Function() playerDrewCard,
      required R Function(UnoPlayerId player) playerSnitchedUno});

  @override
  int get hashCode => throw UnimplementedError(
      'Each case has its own implementation of hashCode');
  bool operator ==(other) =>
      throw UnimplementedError('Each case has its own implementation of ==');

  String toString() => throw UnimplementedError(
      'Each case has its own implementation of toString');
}

class StartGame extends UnoEvent {
  const StartGame() : super._();

  @override
  int get hashCode => (StartGame).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is StartGame && true);

  @override
  String toString() => "StartGame";

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      startGame();
}

class PlayCard extends UnoEvent {
  final int cardIndex;
  final UnoCardColor? chosenWildcardColor;

  const PlayCard(this.cardIndex, this.chosenWildcardColor) : super._();

  const PlayCard.named(
      {required this.cardIndex, required this.chosenWildcardColor})
      : super._();

  @override
  int get hashCode => Object.hash((PlayCard), cardIndex, chosenWildcardColor);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is PlayCard &&
          true &&
          this.cardIndex == other.cardIndex &&
          this.chosenWildcardColor == other.chosenWildcardColor);

  @override
  String toString() => "PlayCard { $cardIndex, $chosenWildcardColor }";

  PlayCard copyWith(
          {Maybe<int> cardIndex = const Maybe.none(),
          Maybe<UnoCardColor?> chosenWildcardColor = const Maybe.none()}) =>
      PlayCard(cardIndex.valueOr(this.cardIndex),
          chosenWildcardColor.valueOr(this.chosenWildcardColor));

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      playCard(this.cardIndex, this.chosenWildcardColor);
}

class SayUno extends UnoEvent {
  const SayUno() : super._();

  @override
  int get hashCode => (SayUno).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is SayUno && true);

  @override
  String toString() => "SayUno";

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      sayUno();
}

class AddPlayer extends UnoEvent {
  final UnoPlayerId id;
  final String name;

  const AddPlayer(this.id, this.name) : super._();

  const AddPlayer.named({required this.id, required this.name}) : super._();

  @override
  int get hashCode => Object.hash((AddPlayer), id, name);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is AddPlayer &&
          true &&
          this.id == other.id &&
          this.name == other.name);

  @override
  String toString() => "AddPlayer { $id, $name }";

  AddPlayer copyWith(
          {Maybe<UnoPlayerId> id = const Maybe.none(),
          Maybe<String> name = const Maybe.none()}) =>
      AddPlayer(id.valueOr(this.id), name.valueOr(this.name));

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      addPlayer(this.id, this.name);
}

class ChangePlayerName extends UnoEvent {
  final UnoPlayerId id;
  final String name;

  const ChangePlayerName(this.id, this.name) : super._();

  const ChangePlayerName.named({required this.id, required this.name})
      : super._();

  @override
  int get hashCode => Object.hash((ChangePlayerName), id, name);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is ChangePlayerName &&
          true &&
          this.id == other.id &&
          this.name == other.name);

  @override
  String toString() => "ChangePlayerName { $id, $name }";

  ChangePlayerName copyWith(
          {Maybe<UnoPlayerId> id = const Maybe.none(),
          Maybe<String> name = const Maybe.none()}) =>
      ChangePlayerName(id.valueOr(this.id), name.valueOr(this.name));

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      changePlayerName(this.id, this.name);
}

class RemovePlayer extends UnoEvent {
  final UnoPlayerId id;

  const RemovePlayer(this.id) : super._();

  const RemovePlayer.named({required this.id}) : super._();

  @override
  int get hashCode => Object.hash((RemovePlayer), id);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is RemovePlayer && true && this.id == other.id);

  @override
  String toString() => "RemovePlayer { $id }";

  RemovePlayer copyWith({Maybe<UnoPlayerId> id = const Maybe.none()}) =>
      RemovePlayer(id.valueOr(this.id));

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      removePlayer(this.id);
}

class TimePassed extends UnoEvent {
  const TimePassed() : super._();

  @override
  int get hashCode => (TimePassed).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is TimePassed && true);

  @override
  String toString() => "TimePassed";

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      timePassed();
}

class PlayerDrewCard extends UnoEvent {
  const PlayerDrewCard() : super._();

  @override
  int get hashCode => (PlayerDrewCard).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is PlayerDrewCard && true);

  @override
  String toString() => "PlayerDrewCard";

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      playerDrewCard();
}

class PlayerSnitchedUno extends UnoEvent {
  final UnoPlayerId player;

  const PlayerSnitchedUno(this.player) : super._();

  const PlayerSnitchedUno.named({required this.player}) : super._();

  @override
  int get hashCode => Object.hash((PlayerSnitchedUno), player);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is PlayerSnitchedUno && true && this.player == other.player);

  @override
  String toString() => "PlayerSnitchedUno { $player }";

  PlayerSnitchedUno copyWith(
          {Maybe<UnoPlayerId> player = const Maybe.none()}) =>
      PlayerSnitchedUno(player.valueOr(this.player));

  @override
  R visit<R extends Object?>(
          {required R Function() startGame,
          required R Function(int cardIndex, UnoCardColor? chosenWildcardColor)
              playCard,
          required R Function() sayUno,
          required R Function(UnoPlayerId id, String name) addPlayer,
          required R Function(UnoPlayerId id, String name) changePlayerName,
          required R Function(UnoPlayerId id) removePlayer,
          required R Function() timePassed,
          required R Function() playerDrewCard,
          required R Function(UnoPlayerId player) playerSnitchedUno}) =>
      playerSnitchedUno(this.player);
}

class PlayersPlayedCardsAndCardStack
    implements ProductType, TupleN3<PlayerStates, UnoCards, UnoCards> {
  final PlayerStates e0;
  final UnoCards e1;
  final UnoCards e2;

  const PlayersPlayedCardsAndCardStack(this.e0, this.e1, this.e2) : super();

  factory PlayersPlayedCardsAndCardStack.fromTupleN(
          TupleN3<PlayerStates, UnoCards, UnoCards> tpl) =>
      PlayersPlayedCardsAndCardStack(tpl.e0, tpl.e1, tpl.e2);

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([PlayerStates, UnoCards, UnoCards]);

  @override
  int get hashCode => Object.hash((PlayersPlayedCardsAndCardStack), e0, e1, e2);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is PlayersPlayedCardsAndCardStack &&
          true &&
          this.e0 == other.e0 &&
          this.e1 == other.e1 &&
          this.e2 == other.e2);

  @override
  String toString() => "PlayersPlayedCardsAndCardStack ($e0, $e1, $e2)";

  PlayersPlayedCardsAndCardStack copyWith(
          {Maybe<PlayerStates> e0 = const Maybe.none(),
          Maybe<UnoCards> e1 = const Maybe.none(),
          Maybe<UnoCards> e2 = const Maybe.none()}) =>
      PlayersPlayedCardsAndCardStack(
          e0.valueOr(this.e0), e1.valueOr(this.e1), e2.valueOr(this.e2));
}
