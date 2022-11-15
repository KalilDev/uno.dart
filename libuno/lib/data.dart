import 'dart:async';

import 'package:collection/collection.dart';
import 'package:kalil_adt_annotation/kalil_adt_annotation.dart';
import 'package:kalil_utils/utils.dart' hide Tuple;
import 'dart:collection';
part 'data.g.dart';

T enumFromJson<T extends Enum>(Object? value, List<T> values) =>
    values.singleWhere((e) => e.name == value);

String enumToJson<T extends Enum>(T value) => value.name;

bool itEquals<T>(Iterable<T>? a, Iterable<T>? b) =>
    IterableEquality<T>().equals(a, b);
int itHash<T>(Iterable<T>? obj) => IterableEquality<T>().hash(obj);

bool _listEquals<T>(List<T>? a, List<T>? b) => ListEquality<T>().equals(a, b);
int _listHash<T>(List<T>? obj) => ListEquality<T>().hash(obj);

enum UnoCardColor {
  green,
  blue,
  yellow,
  red,
}

const UnoCardColorT = T(
  #UnoCardColor,
  fromJson: 'enumFromJson<UnoCardColor>({}, UnoCardColor.values)',
  toJson: 'enumToJson<UnoCardColor>({})',
);

const nUnoCardColorT = T.n(
  #UnoCardColor,
  fromJson:
      '{} == null ? null : enumFromJson<UnoCardColor>({}, UnoCardColor.values)',
  toJson: '{} == null ? null : enumToJson<UnoCardColor>({}!)',
);

@data(
  #UnoCard,
  [],
  Union(
    {
      #DefaultCard: {#color: UnoCardColorT, #number: T(#int)},
      #ReverseCard: {#color: UnoCardColorT},
      #BlockCard: {#color: UnoCardColorT},
      #PlusTwoCard: {#color: UnoCardColorT},
      #PlusFourCard: {},
      #RainbowCard: {},
    },
    deriveMode: UnionVisitDeriveMode.both,
  ),
  deriveFromJson: true,
)
const Type _UnoCard = UnoCard;
const UnoCardT = T(#UnoCard, fromJson: 'UnoCard.fromJson({})');

typedef UnoCards = Queue<UnoCard>;
const UnoCardsT = T(
  #UnoCards,
  fromJson:
      'UnoCards.of(({} as List<Object?>).map((e) => UnoCard.fromJson(e!)))',
  toJson: 'List<UnoCard>.of({})',
  equality: 'itEquals<UnoCard>({a}, {b})',
  hash: 'itHash<UnoCard>({})',
);

typedef UnoCardList = List<UnoCard>;
const UnoCardListT = T(
  #UnoCardList,
  equality: '_listEquals<UnoCard>({a}, {b})',
  hash: '_listHash<UnoCard>({})',
);

@data(
  #UnoPlayerId,
  [],
  Opaque(
    T(#String),
    exposeConstructor: true,
  ),
  deriveFromJson: true,
)
const Type _UnoPlayerId = UnoPlayerId;
const UnoPlayerIdT = T(
  #UnoPlayerId,
  fromJson: 'UnoPlayerId({} as String)',
  toJson: '{}.unwrap',
);

extension UnoPlayerIdE on UnoPlayerId {
  String get unwrap => _unwrap;
}

@data(
  #UnoState,
  [],
  Record(
    {
      #players: PlayerStatesT,
      #playedCards: UnoCardsT,
      #cardStack: UnoCardsT,
      #currentColor: UnoCardColorT,
      #play: UnoPlayStateT,
    },
  ),
  deriveFromJson: true,
)
const Type _UnoState = UnoState;

@data(
  #UnoPlayerState,
  [],
  Record(
    {
      #id: UnoPlayerIdT,
      #name: T(#String),
      #cards: UnoCardListT,
      #lastPlayTime: T(#DateTime),
      #didUno: T(#bool),
    },
  ),
  deriveFromJson: true,
)
const Type _UnoPlayerState = UnoPlayerState;
const UnoPlayerStateT =
    T(#UnoPlayerState, fromJson: 'UnoPlayerState.fromJson({}!)');

typedef PlayerStates = Map<UnoPlayerId, UnoPlayerState>;
const PlayerStatesT = T(
  #PlayerStates,
  toJson: '{}.map((id, v) => MapEntry(id.toJson(),  v))',
  fromJson: '''({} as Map<String, Object?>)
              .map((id,v) =>
                MapEntry(UnoPlayerId.fromJson(id), UnoPlayerState.fromJson(v!))
              )''',
);

enum UnoDirection { clockwise, counterClockwise }

const UnoDirectionT = T(
  #UnoDirection,
  fromJson: 'enumFromJson<UnoDirection>({}, UnoDirection.values)',
  toJson: 'enumToJson<UnoDirection>({})',
);
@data(
  #AnPlusTwoOrAnPlusFour,
  [],
  Union(
    {
      #AnPlusTwo: {#card: T(#PlusTwoCard)},
      #AnPlusFour: {#card: T(#PlusFourCard)},
    },
  ),
  deriveFromJson: true,
)
const Type _AnPlusTwoOrAnPlusFour = AnPlusTwoOrAnPlusFour;

typedef PlusTwosOrPlusFours = Queue<AnPlusTwoOrAnPlusFour>;
const PlusTwosOrPlusFoursT = T(
  #Queue,
  args: [T(#AnPlusTwoOrAnPlusFour)],
  fromJson:
      'Queue<AnPlusTwoOrAnPlusFour>.of(({} as List<Object?>).map((e) => AnPlusTwoOrAnPlusFour.fromJson(e!)))',
  toJson: 'List<AnPlusTwoOrAnPlusFour>.of({})',
  equality: 'itEquals<AnPlusTwoOrAnPlusFour>({a}, {b})',
  hash: 'itHash<AnPlusTwoOrAnPlusFour>({})',
);
@data(
  #UnoPlayState,
  [],
  Union({
    #UnoPlaying: {
      #startTime: T(#DateTime),
      #playStartTime: T(#DateTime),
      #playRemainingDuration: T(#Duration),
      #currentPlayer: UnoPlayerIdT,
      #direction: UnoDirectionT,
      #stackingPluses: PlusTwosOrPlusFoursT,
    },
    #UnoWaitingStart: {},
    #UnoFinished: {#winner: UnoPlayerIdT, #duration: T(#Duration)},
  }),
  deriveFromJson: true,
)
const Type _UnoPlayState = UnoPlayState;
const UnoPlayStateT = T(#UnoPlayState, fromJson: 'UnoPlayState.fromJson({}!)');

@data(
  #UnoEvent,
  [],
  Union(
    {
      #StartGame: {},
      #PlayCard: {
        #cardIndex: T(#int),
        #chosenWildcardColor: nUnoCardColorT,
      },
      #SayUno: {},
      #AddPlayer: {#id: UnoPlayerIdT, #name: T(#String)},
      #ChangePlayerName: {#id: UnoPlayerIdT, #name: T(#String)},
      #RemovePlayer: {#id: UnoPlayerIdT},
      #TimePassed: {},
      #PlayerDrewCard: {},
      #PlayerSnitchedUno: {#player: UnoPlayerIdT}
    },
  ),
  deriveFromJson: true,
)
const Type _UnoEvent = UnoEvent;

enum UnoRule {
  plusTwoStacksPlusTwo,
  plusFourStacksPlusTwo,
  plusFourStacksPlusFour,
}

extension UnoDirectionE on UnoDirection {
  UnoDirection reverse() {
    switch (this) {
      case UnoDirection.clockwise:
        return UnoDirection.counterClockwise;
      case UnoDirection.counterClockwise:
        return UnoDirection.clockwise;
    }
  }
}
