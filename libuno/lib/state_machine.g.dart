// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_machine.dart';

// **************************************************************************
// AdtGenerator
// **************************************************************************

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
