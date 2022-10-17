// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uno.dart';

// **************************************************************************
// AdtGenerator
// **************************************************************************

enum $UnoCardType {
  DefaultCard,
  ReverseCard,
  BlockCard,
  PlusTwoCard,
  PlusFourCard,
  RainbowCard
}

abstract class UnoCard implements SumType {
  const UnoCard._();
  const factory UnoCard.defaultCard(UnoCardColor color, int number) =
      DefaultCard;
  const factory UnoCard.reverseCard(UnoCardColor color) = ReverseCard;
  const factory UnoCard.blockCard(UnoCardColor color) = BlockCard;
  const factory UnoCard.plusTwoCard(UnoCardColor color) = PlusTwoCard;
  const factory UnoCard.plusFourCard() = PlusFourCard;
  const factory UnoCard.rainbowCard() = RainbowCard;
  factory UnoCard.fromJson(Object json) {
    switch ((json as Map<String, Object?>)["\$type"]) {
      case (r"DefaultCard"):
        return DefaultCard.fromJson(json);

      case (r"ReverseCard"):
        return ReverseCard.fromJson(json);

      case (r"BlockCard"):
        return BlockCard.fromJson(json);

      case (r"PlusTwoCard"):
        return PlusTwoCard.fromJson(json);

      case (r"PlusFourCard"):
        return PlusFourCard.fromJson(json);

      case (r"RainbowCard"):
        return RainbowCard.fromJson(json);

      default:
        throw UnimplementedError("Invalid type");
    }
  }

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

  $UnoCardType get $type => throw UnimplementedError(
      'Each case has its own implementation of type\$');

  Object toJson() => throw UnimplementedError(
      'Each case has its own implementation of toJson');
}

class DefaultCard extends UnoCard {
  final UnoCardColor color;
  final int number;

  const DefaultCard(this.color, this.number) : super._();

  const DefaultCard.named({required this.color, required this.number})
      : super._();

  factory DefaultCard.fromJson(Object json) => DefaultCard(
      (json as Map<String, Object?>)[r"color"] as UnoCardColor,
      (json as Map<String, Object?>)[r"number"] as int);

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
  final $UnoCardType $type = $UnoCardType.DefaultCard;

  Object toJson() => {$type: $type.name, color: color, number: number};

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

  factory ReverseCard.fromJson(Object json) =>
      ReverseCard((json as Map<String, Object?>)[r"color"] as UnoCardColor);

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
  final $UnoCardType $type = $UnoCardType.ReverseCard;

  Object toJson() => {$type: $type.name, color: color};

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

  factory BlockCard.fromJson(Object json) =>
      BlockCard((json as Map<String, Object?>)[r"color"] as UnoCardColor);

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
  final $UnoCardType $type = $UnoCardType.BlockCard;

  Object toJson() => {$type: $type.name, color: color};

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

  factory PlusTwoCard.fromJson(Object json) =>
      PlusTwoCard((json as Map<String, Object?>)[r"color"] as UnoCardColor);

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
  final $UnoCardType $type = $UnoCardType.PlusTwoCard;

  Object toJson() => {$type: $type.name, color: color};

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

  factory PlusFourCard.fromJson(Object json) => PlusFourCard();

  @override
  int get hashCode => (PlusFourCard).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is PlusFourCard && true);

  @override
  String toString() => "PlusFourCard";

  @override
  final $UnoCardType $type = $UnoCardType.PlusFourCard;

  Object toJson() => {
        $type: $type.name,
      };

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

  factory RainbowCard.fromJson(Object json) => RainbowCard();

  @override
  int get hashCode => (RainbowCard).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is RainbowCard && true);

  @override
  String toString() => "RainbowCard";

  @override
  final $UnoCardType $type = $UnoCardType.RainbowCard;

  Object toJson() => {
        $type: $type.name,
      };

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

  factory UnoPlayerId.fromJson(Object json) =>
      UnoPlayerId((json as Map<String, Object?>)[r"_unwrap"] as String);

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

  Object toJson() => {_unwrap: _unwrap};
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

  factory UnoState.fromJson(Object json) => UnoState(
      (json as Map<String, Object?>)[r"players"] as PlayerStates,
      (json as Map<String, Object?>)[r"playedCards"] as UnoCards,
      (json as Map<String, Object?>)[r"cardStack"] as UnoCards,
      (json as Map<String, Object?>)[r"currentColor"] as UnoCardColor,
      (json as Map<String, Object?>)[r"play"] as UnoPlayState);

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

  Object toJson() => {
        players: players,
        playedCards: playedCards,
        cardStack: cardStack,
        currentColor: currentColor,
        play: play
      };
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

  factory UnoPlayerState.fromJson(Object json) => UnoPlayerState(
      (json as Map<String, Object?>)[r"id"] as UnoPlayerId,
      (json as Map<String, Object?>)[r"name"] as String,
      (json as Map<String, Object?>)[r"cards"] as UnoCardList,
      (json as Map<String, Object?>)[r"lastPlayTime"] as DateTime,
      (json as Map<String, Object?>)[r"didUno"] as bool);

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

  Object toJson() => {
        id: id,
        name: name,
        cards: cards,
        lastPlayTime: lastPlayTime,
        didUno: didUno
      };
}

enum $AnPlusTwoOrAnPlusFourType { AnPlusTwo, AnPlusFour }

abstract class AnPlusTwoOrAnPlusFour implements SumType {
  const AnPlusTwoOrAnPlusFour._();
  const factory AnPlusTwoOrAnPlusFour.anPlusTwo(PlusTwoCard card) = AnPlusTwo;
  const factory AnPlusTwoOrAnPlusFour.anPlusFour(PlusFourCard card) =
      AnPlusFour;
  factory AnPlusTwoOrAnPlusFour.fromJson(Object json) {
    switch ((json as Map<String, Object?>)["\$type"]) {
      case (r"AnPlusTwo"):
        return AnPlusTwo.fromJson(json);

      case (r"AnPlusFour"):
        return AnPlusFour.fromJson(json);

      default:
        throw UnimplementedError("Invalid type");
    }
  }

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

  $AnPlusTwoOrAnPlusFourType get $type => throw UnimplementedError(
      'Each case has its own implementation of type\$');

  Object toJson() => throw UnimplementedError(
      'Each case has its own implementation of toJson');
}

class AnPlusTwo extends AnPlusTwoOrAnPlusFour {
  final PlusTwoCard card;

  const AnPlusTwo(this.card) : super._();

  const AnPlusTwo.named({required this.card}) : super._();

  factory AnPlusTwo.fromJson(Object json) =>
      AnPlusTwo((json as Map<String, Object?>)[r"card"] as PlusTwoCard);

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
  final $AnPlusTwoOrAnPlusFourType $type = $AnPlusTwoOrAnPlusFourType.AnPlusTwo;

  Object toJson() => {$type: $type.name, card: card};

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

  factory AnPlusFour.fromJson(Object json) =>
      AnPlusFour((json as Map<String, Object?>)[r"card"] as PlusFourCard);

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
  final $AnPlusTwoOrAnPlusFourType $type =
      $AnPlusTwoOrAnPlusFourType.AnPlusFour;

  Object toJson() => {$type: $type.name, card: card};

  @override
  R visit<R extends Object?>(
          {required R Function(PlusTwoCard card) anPlusTwo,
          required R Function(PlusFourCard card) anPlusFour}) =>
      anPlusFour(this.card);
}

enum $UnoPlayStateType { UnoPlaying, UnoWaitingStart, UnoFinished }

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
  factory UnoPlayState.fromJson(Object json) {
    switch ((json as Map<String, Object?>)["\$type"]) {
      case (r"UnoPlaying"):
        return UnoPlaying.fromJson(json);

      case (r"UnoWaitingStart"):
        return UnoWaitingStart.fromJson(json);

      case (r"UnoFinished"):
        return UnoFinished.fromJson(json);

      default:
        throw UnimplementedError("Invalid type");
    }
  }

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

  $UnoPlayStateType get $type => throw UnimplementedError(
      'Each case has its own implementation of type\$');

  Object toJson() => throw UnimplementedError(
      'Each case has its own implementation of toJson');
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

  factory UnoPlaying.fromJson(Object json) => UnoPlaying(
      (json as Map<String, Object?>)[r"startTime"] as DateTime,
      (json as Map<String, Object?>)[r"playStartTime"] as DateTime,
      (json as Map<String, Object?>)[r"playRemainingDuration"] as Duration,
      (json as Map<String, Object?>)[r"currentPlayer"] as UnoPlayerId,
      (json as Map<String, Object?>)[r"direction"] as UnoDirection,
      (json as Map<String, Object?>)[r"stackingPluses"]
          as Queue<AnPlusTwoOrAnPlusFour>);

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
  final $UnoPlayStateType $type = $UnoPlayStateType.UnoPlaying;

  Object toJson() => {
        $type: $type.name,
        startTime: startTime,
        playStartTime: playStartTime,
        playRemainingDuration: playRemainingDuration,
        currentPlayer: currentPlayer,
        direction: direction,
        stackingPluses: stackingPluses
      };

  @override
  R visit<R extends Object?>(
          {required R Function(UnoPlaying) unoPlaying,
          required R Function(UnoWaitingStart) unoWaitingStart,
          required R Function(UnoFinished) unoFinished}) =>
      unoPlaying(this);
}

class UnoWaitingStart extends UnoPlayState {
  const UnoWaitingStart() : super._();

  factory UnoWaitingStart.fromJson(Object json) => UnoWaitingStart();

  @override
  int get hashCode => (UnoWaitingStart).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is UnoWaitingStart && true);

  @override
  String toString() => "UnoWaitingStart";

  @override
  final $UnoPlayStateType $type = $UnoPlayStateType.UnoWaitingStart;

  Object toJson() => {
        $type: $type.name,
      };

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

  factory UnoFinished.fromJson(Object json) => UnoFinished(
      (json as Map<String, Object?>)[r"winner"] as UnoPlayerId,
      (json as Map<String, Object?>)[r"duration"] as Duration);

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
  final $UnoPlayStateType $type = $UnoPlayStateType.UnoFinished;

  Object toJson() => {$type: $type.name, winner: winner, duration: duration};

  @override
  R visit<R extends Object?>(
          {required R Function(UnoPlaying) unoPlaying,
          required R Function(UnoWaitingStart) unoWaitingStart,
          required R Function(UnoFinished) unoFinished}) =>
      unoFinished(this);
}

enum $UnoEventType {
  StartGame,
  PlayCard,
  SayUno,
  AddPlayer,
  ChangePlayerName,
  RemovePlayer,
  TimePassed,
  PlayerDrewCard,
  PlayerSnitchedUno
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
  factory UnoEvent.fromJson(Object json) {
    switch ((json as Map<String, Object?>)["\$type"]) {
      case (r"StartGame"):
        return StartGame.fromJson(json);

      case (r"PlayCard"):
        return PlayCard.fromJson(json);

      case (r"SayUno"):
        return SayUno.fromJson(json);

      case (r"AddPlayer"):
        return AddPlayer.fromJson(json);

      case (r"ChangePlayerName"):
        return ChangePlayerName.fromJson(json);

      case (r"RemovePlayer"):
        return RemovePlayer.fromJson(json);

      case (r"TimePassed"):
        return TimePassed.fromJson(json);

      case (r"PlayerDrewCard"):
        return PlayerDrewCard.fromJson(json);

      case (r"PlayerSnitchedUno"):
        return PlayerSnitchedUno.fromJson(json);

      default:
        throw UnimplementedError("Invalid type");
    }
  }

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

  $UnoEventType get $type => throw UnimplementedError(
      'Each case has its own implementation of type\$');

  Object toJson() => throw UnimplementedError(
      'Each case has its own implementation of toJson');
}

class StartGame extends UnoEvent {
  const StartGame() : super._();

  factory StartGame.fromJson(Object json) => StartGame();

  @override
  int get hashCode => (StartGame).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is StartGame && true);

  @override
  String toString() => "StartGame";

  @override
  final $UnoEventType $type = $UnoEventType.StartGame;

  Object toJson() => {
        $type: $type.name,
      };

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

  factory PlayCard.fromJson(Object json) => PlayCard(
      (json as Map<String, Object?>)[r"cardIndex"] as int,
      (json as Map<String, Object?>)[r"chosenWildcardColor"] as UnoCardColor?);

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
  final $UnoEventType $type = $UnoEventType.PlayCard;

  Object toJson() => {
        $type: $type.name,
        cardIndex: cardIndex,
        chosenWildcardColor: chosenWildcardColor
      };

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

  factory SayUno.fromJson(Object json) => SayUno();

  @override
  int get hashCode => (SayUno).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is SayUno && true);

  @override
  String toString() => "SayUno";

  @override
  final $UnoEventType $type = $UnoEventType.SayUno;

  Object toJson() => {
        $type: $type.name,
      };

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

  factory AddPlayer.fromJson(Object json) => AddPlayer(
      (json as Map<String, Object?>)[r"id"] as UnoPlayerId,
      (json as Map<String, Object?>)[r"name"] as String);

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
  final $UnoEventType $type = $UnoEventType.AddPlayer;

  Object toJson() => {$type: $type.name, id: id, name: name};

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

  factory ChangePlayerName.fromJson(Object json) => ChangePlayerName(
      (json as Map<String, Object?>)[r"id"] as UnoPlayerId,
      (json as Map<String, Object?>)[r"name"] as String);

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
  final $UnoEventType $type = $UnoEventType.ChangePlayerName;

  Object toJson() => {$type: $type.name, id: id, name: name};

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

  factory RemovePlayer.fromJson(Object json) =>
      RemovePlayer((json as Map<String, Object?>)[r"id"] as UnoPlayerId);

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
  final $UnoEventType $type = $UnoEventType.RemovePlayer;

  Object toJson() => {$type: $type.name, id: id};

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

  factory TimePassed.fromJson(Object json) => TimePassed();

  @override
  int get hashCode => (TimePassed).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is TimePassed && true);

  @override
  String toString() => "TimePassed";

  @override
  final $UnoEventType $type = $UnoEventType.TimePassed;

  Object toJson() => {
        $type: $type.name,
      };

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

  factory PlayerDrewCard.fromJson(Object json) => PlayerDrewCard();

  @override
  int get hashCode => (PlayerDrewCard).hashCode;
  @override
  bool operator ==(other) =>
      identical(this, other) || (other is PlayerDrewCard && true);

  @override
  String toString() => "PlayerDrewCard";

  @override
  final $UnoEventType $type = $UnoEventType.PlayerDrewCard;

  Object toJson() => {
        $type: $type.name,
      };

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

  factory PlayerSnitchedUno.fromJson(Object json) => PlayerSnitchedUno(
      (json as Map<String, Object?>)[r"player"] as UnoPlayerId);

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
  final $UnoEventType $type = $UnoEventType.PlayerSnitchedUno;

  Object toJson() => {$type: $type.name, player: player};

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

  factory PlayersPlayedCardsAndCardStack.fromJson(Object json) =>
      PlayersPlayedCardsAndCardStack(
          (json as List<Object?>)[0] as PlayerStates,
          (json as List<Object?>)[1] as UnoCards,
          (json as List<Object?>)[2] as UnoCards);

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

  Object toJson() => [e0, e1, e2];
}
