import 'dart:async';

import 'package:app/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:kalil_utils/utils.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';

void main() {
  runDynamicallyThemedApp(const MyApp(), fallback: () => baseline3PCorePalette);
}

extension on UnoAppColorScheme {
  CustomColorScheme fromUnoCardColor(UnoCardColor color) {
    switch (color) {
      case UnoCardColor.green:
        return green;
      case UnoCardColor.blue:
        return blue;
      case UnoCardColor.yellow:
        return yellow;
      case UnoCardColor.red:
        return red;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MD3ThemedApp<UnoAppColorScheme, UnoAppColorTheme>(
      appThemeFactory: UnoAppColorTheme.fromMonetTheme,
      builder: (context, light, dark) => MaterialApp(
        title: 'Flutter Demo',
        theme: light,
        darkTheme: dark,
        builder: (context, home) =>
            AnimatedMonetColorSchemes<UnoAppColorScheme, UnoAppColorTheme>(
          child: home!,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class UnoCardW extends StatelessWidget {
  const UnoCardW({
    super.key,
    required this.card,
    this.onPressed,
  });
  final UnoCard card;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColorScheme;
    final color = card.visitC(
      defaultCard: (color, _) => colors.fromUnoCardColor(color),
      reverseCard: colors.fromUnoCardColor,
      blockCard: colors.fromUnoCardColor,
      plusTwoCard: colors.fromUnoCardColor,
      plusFourCard: () => colors.black,
      rainbowCard: () => colors.black,
    );
    final content = card.visitC(
      defaultCard: (_, number) => Text(number.toString()),
      reverseCard: (_) => Icon(Icons.refresh),
      blockCard: (_) => Icon(Icons.block),
      plusTwoCard: (_) => Text("+2"),
      plusFourCard: () => Text("+4"),
      rainbowCard: () => Text("🏳️‍🌈"),
    );
    return ColoredCard(
      color: color,
      child: Center(
        child: content,
      ),
      onPressed: onPressed,
    );
  }
}

class UnoCardBackW extends StatelessWidget {
  const UnoCardBackW({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ColoredCard(
      color: context.appColorScheme.black,
      child: Center(
        child: Text("Uno"),
      ),
      onPressed: onPressed,
    );
  }
}

class UnoCardContainer extends StatelessWidget {
  const UnoCardContainer({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 8 / 11.5,
        child: child,
      );
}

class UnoCardListW extends StatelessWidget {
  const UnoCardListW({
    super.key,
    required this.cards,
    this.onPressed,
    required this.axis,
    this.isBack = false,
  });
  final UnoCardList cards;
  final ValueChanged<int>? onPressed;
  final Axis axis;
  final bool isBack;

  Widget _buildCard(BuildContext context, int i) => UnoCardContainer(
        child: UnoCardW(
          card: cards[i],
          onPressed: onPressed == null ? null : () => onPressed!.call(i),
        ),
      );

  Widget _buildBackCard(BuildContext context, int i) => UnoCardContainer(
        child: UnoCardBackW(
          onPressed: onPressed == null ? null : () => onPressed!.call(i),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: isBack ? _buildBackCard : _buildCard,
      itemCount: cards.length,
      scrollDirection: axis,
    );
  }
}

class UnoCardsContainer extends StatelessWidget {
  const UnoCardsContainer({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300 * (11.5 / 8),
      child: child,
    );
  }
}

Iterable<T> reversed<T>(Iterable<T> it) sync* {
  final list = it.toList();
  for (var i = list.length - 1; i >= 0; i--) {
    yield list[i];
  }
}

class BackUnoCardsW extends StatelessWidget {
  const BackUnoCardsW({
    super.key,
    required this.cards,
    this.onPressed,
  });
  final UnoCards cards;
  final ValueChanged<int>? onPressed;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          for (final card in cards.indexed)
            Positioned(
              child: UnoCardContainer(
                child: UnoCardBackW(
                  onPressed: onPressed == null
                      ? null
                      : () => onPressed!.call(
                            card.e0,
                          ),
                ),
              ),
              left: card.e0 * 2,
              top: card.e0 * 2,
            )
        ],
      );
}

class UnoCardsW extends StatelessWidget {
  const UnoCardsW({
    super.key,
    required this.cards,
    this.onPressed,
  });
  final UnoCards cards;
  final ValueChanged<int>? onPressed;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          for (final card in reversed(cards).indexed)
            Positioned(
              child: UnoCardContainer(
                child: UnoCardW(
                  card: card.e1,
                  onPressed: onPressed == null
                      ? null
                      : () => onPressed!.call(
                            card.e0,
                          ),
                ),
              ),
              left: 0,
              top: 0,
              bottom: card.e0 * 2,
              right: card.e0 * 2,
            )
        ],
      );
}

class CardStackAndPlayedCardsW extends StatelessWidget {
  const CardStackAndPlayedCardsW({
    super.key,
    required this.playedCards,
    this.onPlayedCards,
    required this.cardStack,
    this.onCardStack,
  });
  final UnoCards playedCards;
  final ValueChanged<int>? onPlayedCards;
  final UnoCards cardStack;
  final ValueChanged<int>? onCardStack;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        UnoCardsContainer(
          child: UnoCardsW(
            cards: playedCards,
            onPressed: onPlayedCards,
          ),
        ),
        UnoCardsContainer(
          child: UnoCardsW(
            cards: cardStack,
            onPressed: onCardStack,
          ),
        ),
      ],
    );
  }
}

class PlayerW extends StatelessWidget {
  const PlayerW({
    super.key,
    required this.state,
  });
  final UnoPlayerState state;

  Widget _col(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.id.toString()),
          Text(state.name.toString()),
          SizedBox(
            height: 100,
            child: UnoCardListW(
              cards: state.cards,
              axis: Axis.horizontal,
            ),
          ),
          Text(state.lastPlayTime.toString()),
          Text('didUno: ${state.didUno}'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.sizeClass.minimumMargins,
        vertical: context.sizeClass.minimumMargins / 4,
      ),
      child: _col(context),
    );
  }
}

class PlayStateW extends StatelessWidget {
  const PlayStateW({
    super.key,
    required this.state,
  });
  final UnoPlayState state;

  Widget _playingCol(BuildContext context, UnoPlaying state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("playing"),
          Text(state.startTime.toString()),
          Text(state.playStartTime.toString()),
          Text(state.playRemainingDuration.toString()),
          Text(state.currentPlayer.toString()),
          Text(state.direction.toString()),
          if (state.stackingPluses.isNotEmpty)
            UnoCardsContainer(
              child: UnoCardsW(
                cards: UnoCards.of(
                  state.stackingPluses.map(
                    (p) => p.visit(
                      anPlusTwo: identity,
                      anPlusFour: identity,
                    ),
                  ),
                ),
              ),
            )
        ],
      );
  Widget _waitingStartCol(BuildContext context, UnoWaitingStart state) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("waiting start"),
        ],
      );
  Widget _finishedCol(BuildContext context, UnoFinished state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("finished"),
          Text(state.winner.toString()),
          Text(state.duration.toString()),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.sizeClass.minimumMargins,
        vertical: context.sizeClass.minimumMargins / 4,
      ),
      child: state.visit(
        unoPlaying: _playingCol.curry(context),
        unoWaitingStart: _waitingStartCol.curry(context),
        unoFinished: _finishedCol.curry(context),
      ),
    );
  }
}

class StateW extends StatelessWidget {
  const StateW({
    super.key,
    required this.state,
  });
  final UnoState state;
  Widget _col(BuildContext context) => ListView(
        children: [
          PlayStateW(
            state: state.play,
          ),
          CardStackAndPlayedCardsW(
            playedCards: state.playedCards,
            cardStack: state.cardStack,
          ),
          for (final player in state.players.values) PlayerW(state: player),
          Text("Current color: ${state.currentColor}"),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.sizeClass.minimumMargins,
        vertical: context.sizeClass.minimumMargins / 4,
      ),
      child: _col(context),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _PlayCardDialog extends StatefulWidget {
  const _PlayCardDialog({super.key, required this.state});
  final UnoState state;

  @override
  State<_PlayCardDialog> createState() => __PlayCardDialogState();
}

class __PlayCardDialogState extends State<_PlayCardDialog> {
  int? selectedCard;
  UnoCardColor? selectedColor;

  void _selectCard(int i) {
    setState(() => selectedCard = i);
  }

  void _selectColor(UnoCardColor? color) {
    setState(() => selectedColor = color);
  }

  Widget _saveButton(BuildContext context) => IconButton(
        onPressed: () => selectedCard != null
            ? Navigator.of(context).pop(TupleN2(selectedCard!, selectedColor))
            : null,
        icon: Icon(Icons.save_outlined),
      );

  @override
  Widget build(BuildContext context) {
    final cards = widget
        .state.players[(widget.state.play as UnoPlaying).currentPlayer]!.cards;
    return MD3FullScreenDialog(
      action: _saveButton(context),
      body: ListView(
        children: [
          if (selectedCard != null)
            SizedBox(
              height: 100,
              child: UnoCardContainer(
                child: UnoCardW(card: cards[selectedCard!]),
              ),
            ),
          SizedBox(
            height: 100,
            child: UnoCardListW(
              cards: cards,
              axis: Axis.horizontal,
              onPressed: _selectCard,
            ),
          ),
          if (selectedCard != null && isWildcard(cards[selectedCard!]))
            MD3PopupMenuButton(
                initialValue: selectedColor,
                onSelected: _selectColor,
                itemBuilder: (context) => UnoCardColor.values
                    .map((e) => MD3PopupMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                menuKind: MD3PopupMenuKind.selection)
        ],
      ),
    );
  }
}

Future<TupleN2<int, UnoCardColor?>?> showPlayCardDialog(
        BuildContext context, UnoState state) =>
    showDialog(
      context: context,
      builder: (context) => _PlayCardDialog(state: state),
    );

class _MyHomePageState extends State<MyHomePage> {
  UnoStateMachine _machine = ActualUnoStateMachine(
    7,
    Duration(seconds: 30),
    Duration(seconds: 5),
    {
      UnoRule.plusFourStacksPlusFour,
      UnoRule.plusFourStacksPlusTwo,
      UnoRule.plusTwoStacksPlusTwo,
    },
  );
  bool isPaused = true;
  late StreamSubscription<void> ticker;

  void initState() {
    super.initState();
    ticker = Stream.periodic(Duration(milliseconds: 500))
        .listen((event) => _machine.dispatch(TimePassed()));
    isPaused = false;
  }

  void _togglePause() {
    setState(() {});
    if (isPaused) {
      ticker.resume();
      isPaused = false;
      return;
    }
    ticker.pause();
    isPaused = true;
  }

  static int playerId = 0;

  void _addEvent(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          ListTile(
            title: Text("Start Game"),
            onTap: () => _machine.dispatch(StartGame()),
          ),
          ListTile(
            title: Text("Play Card"),
            onTap: () async {
              final wasPaused = isPaused;
              if (!wasPaused) {
                _togglePause();
              }
              final r =
                  await showPlayCardDialog(context, _machine.currentState);
              if (!wasPaused) {
                _togglePause();
              }
              if (r == null) {
                return;
              }
              _machine.dispatch(PlayCard(r.e0, r.e1));
            },
          ),
          ListTile(
            title: Text("Say Uno"),
            onTap: () => _machine.dispatch(SayUno()),
          ),
          ListTile(
            title: Text("Add Player"),
            onTap: () {
              final id = playerId++;
              _machine.dispatch(
                AddPlayer(
                  UnoPlayerId(id.toString()),
                  "player ${id}",
                ),
              );
            },
          ),
          ListTile(
            title: Text("Draw card"),
            onTap: () => _machine.dispatch(PlayerDrewCard()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return MD3AdaptativeScaffold(
      appBar: MD3CenterAlignedAppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        trailing: IconButton(
          onPressed: _togglePause,
          icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
        ),
      ),
      body: MD3ScaffoldBody.noMargin(
        child: StreamBuilder(
          stream: _machine.state,
          builder: (context, snap) => snap.hasData
              ? StateW(state: snap.requireData)
              : CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: MD3FloatingActionButton.expanded(
        onPressed: () => _addEvent(context),
        label: Text('Add event'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
