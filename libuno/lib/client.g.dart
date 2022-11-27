// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// AdtGenerator
// **************************************************************************

class PlayerClientState implements ProductType {
  final UnoPlayerId id;
  final String name;
  final int cardCount;
  final DateTime lastPlayTime;
  final bool didUno;

  const PlayerClientState(
      this.id, this.name, this.cardCount, this.lastPlayTime, this.didUno)
      : super();

  const PlayerClientState.named(
      {required this.id,
      required this.name,
      required this.cardCount,
      required this.lastPlayTime,
      required this.didUno})
      : super();

  factory PlayerClientState.fromJson(Object json) => PlayerClientState(
      UnoPlayerId((json as Map<String, Object?>)[r"id"] as String),
      (json as Map<String, Object?>)[r"name"] as String,
      (json as Map<String, Object?>)[r"cardCount"] as int,
      (json as Map<String, Object?>)[r"lastPlayTime"] as DateTime,
      (json as Map<String, Object?>)[r"didUno"] as bool);

  @override
  ProductRuntimeType get runtimeType =>
      ProductRuntimeType([UnoPlayerId, String, int, DateTime, bool]);

  @override
  int get hashCode => Object.hash(
      (PlayerClientState), id, name, cardCount, lastPlayTime, didUno);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is PlayerClientState &&
          true &&
          this.id == other.id &&
          this.name == other.name &&
          this.cardCount == other.cardCount &&
          this.lastPlayTime == other.lastPlayTime &&
          this.didUno == other.didUno);

  @override
  String toString() =>
      "PlayerClientState { $id, $name, $cardCount, $lastPlayTime, $didUno }";

  PlayerClientState copyWith(
          {Maybe<UnoPlayerId> id = const Maybe.none(),
          Maybe<String> name = const Maybe.none(),
          Maybe<int> cardCount = const Maybe.none(),
          Maybe<DateTime> lastPlayTime = const Maybe.none(),
          Maybe<bool> didUno = const Maybe.none()}) =>
      PlayerClientState(
          id.valueOr(this.id),
          name.valueOr(this.name),
          cardCount.valueOr(this.cardCount),
          lastPlayTime.valueOr(this.lastPlayTime),
          didUno.valueOr(this.didUno));

  Object toJson() => {
        id: id.unwrap,
        name: name,
        cardCount: cardCount,
        lastPlayTime: lastPlayTime,
        didUno: didUno
      };
}

class UnoClientState implements ProductType {
  final PlayerClientStates players;
  final UnoPlayerState player;
  final UnoCards playedCards;
  final int cardStackLength;
  final UnoCardColor currentColor;
  final UnoPlayState play;

  const UnoClientState(this.players, this.player, this.playedCards,
      this.cardStackLength, this.currentColor, this.play)
      : super();

  const UnoClientState.named(
      {required this.players,
      required this.player,
      required this.playedCards,
      required this.cardStackLength,
      required this.currentColor,
      required this.play})
      : super();

  factory UnoClientState.fromJson(Object json) => UnoClientState(
      ((json as Map<String, Object?>)[r"players"] as Map<String, Object?>).map(
          (id, v) => MapEntry(
              UnoPlayerId.fromJson(id), PlayerClientState.fromJson(v!))),
      UnoPlayerState.fromJson((json as Map<String, Object?>)[r"player"]!),
      UnoCards.of(
          ((json as Map<String, Object?>)[r"playedCards"] as List<Object?>)
              .map((e) => UnoCard.fromJson(e!))),
      (json as Map<String, Object?>)[r"cardStackLength"] as int,
      enumFromJson<UnoCardColor>(
          (json as Map<String, Object?>)[r"currentColor"], UnoCardColor.values),
      UnoPlayState.fromJson((json as Map<String, Object?>)[r"play"]!));

  @override
  ProductRuntimeType get runtimeType => ProductRuntimeType([
        PlayerClientStates,
        UnoPlayerState,
        UnoCards,
        int,
        UnoCardColor,
        UnoPlayState
      ]);

  @override
  int get hashCode => Object.hash((UnoClientState), players, player,
      itHash<UnoCard>(playedCards), cardStackLength, currentColor, play);
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is UnoClientState &&
          true &&
          this.players == other.players &&
          this.player == other.player &&
          itEquals<UnoCard>(this.playedCards, other.playedCards) &&
          this.cardStackLength == other.cardStackLength &&
          this.currentColor == other.currentColor &&
          this.play == other.play);

  @override
  String toString() =>
      "UnoClientState { $players, $player, $playedCards, $cardStackLength, $currentColor, $play }";

  UnoClientState copyWith(
          {Maybe<PlayerClientStates> players = const Maybe.none(),
          Maybe<UnoPlayerState> player = const Maybe.none(),
          Maybe<UnoCards> playedCards = const Maybe.none(),
          Maybe<int> cardStackLength = const Maybe.none(),
          Maybe<UnoCardColor> currentColor = const Maybe.none(),
          Maybe<UnoPlayState> play = const Maybe.none()}) =>
      UnoClientState(
          players.valueOr(this.players),
          player.valueOr(this.player),
          playedCards.valueOr(this.playedCards),
          cardStackLength.valueOr(this.cardStackLength),
          currentColor.valueOr(this.currentColor),
          play.valueOr(this.play));

  Object toJson() => {
        players: players.map((id, v) => MapEntry(id.toJson(), v)),
        player: player,
        playedCards: List<UnoCard>.of(playedCards),
        cardStackLength: cardStackLength,
        currentColor: enumToJson<UnoCardColor>(currentColor),
        play: play
      };
}
