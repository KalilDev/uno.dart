import 'dart:async';
import 'dart:ui';

import 'package:app/color_scheme.dart';
import 'package:app/vector.dart' as vd;
import 'package:flutter/material.dart';
import 'package:kalil_utils/utils.dart';
import 'package:libuno/client.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:vector_drawable/vector_drawable.dart' hide Path;
import 'package:vector_math/vector_math_64.dart' hide Vector;

import '3d_stack.dart';

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

final addPlayer = server.addPlayer("Pedro");

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
        home: FutureBuilder(
            future: addPlayer,
            builder: (context, id) => id.hasData
                ? MyHomePage(client: DirectClient(id.requireData, server))
                : CircularProgressIndicator()),
      ),
    );
  }
}

Map<String, Color> styleMappings() => {
      "background": vd.blackC,
      "foreground": vd.whiteC,
      "green": vd.greenC,
      "yellow": vd.yellowC,
      "blue": vd.blueC,
      "red": vd.redC,
    };

Map<String, Color> md3StyleMappingsFromScheme(UnoAppColorScheme colors) => {
      "background": vd.blackC,
      "foreground": vd.whiteC,
      "green": colors.green.color,
      "yellow": colors.yellow.color,
      "blue": colors.blue.color,
      "red": colors.red.color,
    };

class UnoCardW extends StatelessWidget {
  const UnoCardW({
    super.key,
    required this.card,
    this.onPressed,
  });
  final UnoCard card;
  final VoidCallback? onPressed;

  VectorDrawable _vectorForCard() => card.visitC(
        defaultCard: (c, i) => vd.numberedCards[i],
        reverseCard: (c) => vd.reverse,
        blockCard: (c) => vd.block,
        plusTwoCard: (c) => vd.plusTwo,
        plusFourCard: () => vd.plusFour,
        rainbowCard: () => vd.rainbow,
      );

  StyleResolver _mappingForC(UnoCardColor unoColor) {
    final Color color;
    switch (unoColor) {
      case UnoCardColor.green:
        color = vd.greenC;
        break;
      case UnoCardColor.blue:
        color = vd.blueC;
        break;
      case UnoCardColor.yellow:
        color = vd.yellowC;
        break;
      case UnoCardColor.red:
        color = vd.redC;
        break;
    }
    return StyleMapping.fromMap(
      {
        ...styleMappings(),
        "color": color,
      },
      namespace: 'uno',
    );
  }

  StyleResolver _md3MappingForC(BuildContext context, UnoCardColor unoColor) {
    final CustomColorScheme color;
    final colors = context.appColorScheme;
    switch (unoColor) {
      case UnoCardColor.green:
        color = colors.green;
        break;
      case UnoCardColor.blue:
        color = colors.blue;
        break;
      case UnoCardColor.yellow:
        color = colors.yellow;
        break;
      case UnoCardColor.red:
        color = colors.red;
        break;
    }
    return StyleMapping.fromMap(
      {
        ...md3StyleMappingsFromScheme(colors),
        "color": color.colorContainer,
        "foreground": color.onColorContainer
      },
      namespace: 'uno',
    );
  }

  StyleResolver _styleResolver(BuildContext context, bool md3) => card.visitC(
        defaultCard: (c, _) =>
            md3 ? _md3MappingForC(context, c) : _mappingForC(c),
        reverseCard: md3 ? _md3MappingForC.curry(context) : _mappingForC,
        blockCard: md3 ? _md3MappingForC.curry(context) : _mappingForC,
        plusTwoCard: md3 ? _md3MappingForC.curry(context) : _mappingForC,
        plusFourCard: () => vd.defaultStyleMapping,
        rainbowCard: () => vd.defaultStyleMapping,
      );

  @override
  Widget build(BuildContext context) => PressableCard(
        vector: _vectorForCard(),
        styleResolver: _styleResolver(context, false),
        onPressed: onPressed,
      );
}

class PressableCard extends StatelessWidget {
  const PressableCard({
    super.key,
    this.onPressed,
    required this.vector,
    required this.styleResolver,
  });
  final VoidCallback? onPressed;
  final VectorDrawable vector;
  final StyleResolver styleResolver;

  @override
  Widget build(BuildContext context) {
    final w = RawVectorWidget(
      vector: vector.body,
      styleMapping: styleResolver,
    );
    if (onPressed == null) {
      return w;
    }
    return Stack(
      children: [
        Positioned.fill(child: w),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              customBorder: CardShape(),
              child: SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }
}

class CardShape extends OutlinedBorder {
  CardShape({
    BorderSide side = BorderSide.none,
  }) : super(side: side);
  @override
  OutlinedBorder copyWith({BorderSide? side}) => CardShape(
        side: side ?? this.side,
      );

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _shape(rect, textDirection)
          .getInnerPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _shape(rect, textDirection)
          .getOuterPath(rect, textDirection: textDirection);

  OutlinedBorder _shape(Rect rect, TextDirection? textDirection) =>
      RoundedRectangleBorder(
        side: side,
        borderRadius: BorderRadius.circular(
          4.032 * (rect.width / 62),
        ),
      );

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) =>
      _shape(rect, textDirection)
          .paint(canvas, rect, textDirection: textDirection);

  @override
  ShapeBorder scale(double t) => copyWith(side: side.scale(t));
}

class UnoCardBackW extends StatelessWidget {
  const UnoCardBackW({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => PressableCard(
        vector: vd.back,
        styleResolver: vd.defaultStyleMapping,
        onPressed: onPressed,
      );
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
  });
  final UnoCardList cards;
  final ValueChanged<int>? onPressed;
  final Axis axis;

  Widget _buildCard(BuildContext context, int i) => UnoCardContainer(
        child: UnoCardW(
          card: cards[i],
          onPressed: onPressed == null ? null : () => onPressed!.call(i),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildCard,
      itemCount: cards.length,
      scrollDirection: axis,
    );
  }
}

class UnoBackCardListW extends StatelessWidget {
  const UnoBackCardListW({
    super.key,
    required this.cards,
    this.onPressed,
    required this.axis,
  });
  final int cards;
  final ValueChanged<int>? onPressed;
  final Axis axis;

  Widget _buildBackCard(BuildContext context, int i) => UnoCardContainer(
        child: UnoCardBackW(
          onPressed: onPressed == null ? null : () => onPressed!.call(i),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _buildBackCard,
      itemCount: cards,
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
    this.stackDirection,
  });
  final int cards;
  final VoidCallback? onPressed;
  final Vector2? stackDirection;

  @override
  Widget build(BuildContext context) {
    return AnimatedStack3D(
      itemBuilder: (context, i) => UnoCardContainer(
        child: UnoCardBackW(
          onPressed: onPressed == null || i != cards - 1 ? null : onPressed!,
        ),
      ),
      itemCount: cards,
    );
  }
}

class UnoCardsW extends StatelessWidget {
  const UnoCardsW({
    super.key,
    required this.cards,
    this.onPressed,
  });
  final UnoCards cards;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => AnimatedStack3D(
        itemBuilder: (context, i) => UnoCardContainer(
          child: UnoCardW(
            card: cards.elementAt(i),
            onPressed:
                onPressed == null || i != cards.length - 1 ? null : onPressed!,
          ),
        ),
        itemCount: cards.length,
        itemSeparation: 1,
      );
}

class CardStackAndPlayedCardsW extends StatelessWidget {
  const CardStackAndPlayedCardsW({
    super.key,
    required this.playedCards,
    this.onPlayedCards,
    required this.cardStackLength,
    this.onCardStack,
  });
  final UnoCards playedCards;
  final VoidCallback? onPlayedCards;
  final int cardStackLength;
  final VoidCallback? onCardStack;

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
          child: BackUnoCardsW(
            cards: cardStackLength,
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
    this.onCard,
    required this.isPlaying,
  });
  final UnoPlayerState state;
  final bool isPlaying;
  final ValueChanged<int>? onCard;

  Widget _card(BuildContext context, {required Widget child}) {
    final style = CardStyle(
      padding: MaterialStateProperty.all(EdgeInsets.all(16)),
    );
    return isPlaying
        ? ColoredCard(
            color: context.appColorScheme.green,
            child: child,
          )
        : ElevatedCard(child: child);
  }

  Widget _col(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.id.toString()),
          Text(state.name.toString()),
          SizedBox(
            height: 150,
            child: UnoCardListW(
              cards: state.cards,
              axis: Axis.horizontal,
              onPressed: onCard,
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
      child: _card(context, child: _col(context)),
    );
  }
}

class PlayerClientW extends StatelessWidget {
  const PlayerClientW({
    super.key,
    required this.state,
    required this.isPlaying,
  });
  final PlayerClientState state;
  final bool isPlaying;

  Widget _card(BuildContext context, {required Widget child}) {
    final style = CardStyle(
      padding: MaterialStateProperty.all(EdgeInsets.all(16)),
    );
    return isPlaying
        ? ColoredCard(
            color: context.appColorScheme.blue,
            child: child,
          )
        : ElevatedCard(child: child);
  }

  Widget _col(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(state.id.toString()),
          Text(state.name.toString()),
          SizedBox(
            height: 120,
            child: UnoBackCardListW(
              cards: state.cardCount,
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
      child: _card(context, child: _col(context)),
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

class ColorSelectDialog extends StatelessWidget {
  const ColorSelectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MD3BasicDialog(
      title: Text('Selecionar Cor'),
      content: Column(
        children: [
          ColorSelectDialogTile(
            colorScheme: context.appColorScheme.green,
            unoColor: UnoCardColor.green,
            child: Text('Verde'),
          ),
          ColorSelectDialogTile(
            colorScheme: context.appColorScheme.blue,
            unoColor: UnoCardColor.blue,
            child: Text('Azul'),
          ),
          ColorSelectDialogTile(
            colorScheme: context.appColorScheme.red,
            unoColor: UnoCardColor.red,
            child: Text('Vermelho'),
          ),
          ColorSelectDialogTile(
            colorScheme: context.appColorScheme.yellow,
            unoColor: UnoCardColor.yellow,
            child: Text('Amarelo'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'))
      ],
    );
  }
}

class ColorSelectDialogTile extends StatelessWidget {
  const ColorSelectDialogTile({
    Key? key,
    required this.colorScheme,
    required this.unoColor,
    required this.child,
  }) : super(key: key);
  final CustomColorScheme colorScheme;
  final UnoCardColor unoColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.colorContainer,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => Navigator.of(context).pop(UnoCardColor.green),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: DefaultTextStyle.merge(
              child: SizedBox(width: double.infinity, child: child),
              style: TextStyle(color: colorScheme.onColorContainer)),
        ),
      ),
    );
  }
}

class StateW extends StatelessWidget {
  const StateW({
    super.key,
    required this.state,
    required this.onEatCard,
    required this.onPlayCard,
  });
  final UnoClientState state;
  final VoidCallback onEatCard;
  final void Function(int, [UnoCardColor?]) onPlayCard;
  void _playCard(BuildContext context, int i) async {
    if (!isWildcard(state.player.cards[i])) {
      onPlayCard(i);
      return;
    }
    final color = await showDialog<UnoCardColor>(
        context: context, builder: (context) => ColorSelectDialog());
    if (color == null) {
      return;
    }
    onPlayCard(i, color);
  }

  Widget _col(BuildContext context) => ListView(
        children: [
          PlayStateW(
            state: state.play,
          ),
          CardStackAndPlayedCardsW(
            playedCards: state.playedCards,
            cardStackLength: state.cardStackLength,
            onCardStack: state.play.visit(
              unoPlaying: (playing) =>
                  playing.currentPlayer == state.player.id ? onEatCard : null,
              unoWaitingStart: (_) => null,
              unoFinished: (_) => null,
            ),
          ),
          for (final player in state.players.values)
            player.id == state.player.id
                ? PlayerW(
                    state: state.player,
                    onCard: state.play.visit(
                      unoPlaying: (playing) =>
                          playing.currentPlayer == player.id
                              ? _playCard.curry(context)
                              : null,
                      unoWaitingStart: (_) => null,
                      unoFinished: (_) => null,
                    ),
                    isPlaying: state.play.visit(
                      unoPlaying: (playing) =>
                          playing.currentPlayer == player.id,
                      unoWaitingStart: (_) => false,
                      unoFinished: (_) => false,
                    ),
                  )
                : PlayerClientW(
                    state: player,
                    isPlaying: state.play.visit(
                      unoPlaying: (playing) =>
                          playing.currentPlayer == player.id,
                      unoWaitingStart: (_) => false,
                      unoFinished: (_) => false,
                    ),
                  ),
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

final server = BasicServer()..start();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.client});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final UnoClient client;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _PlayCardDialog extends StatefulWidget {
  const _PlayCardDialog({super.key, required this.state});
  final UnoPlayerState state;

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
    return MD3FullScreenDialog(
      action: _saveButton(context),
      body: ListView(
        children: [
          if (selectedCard != null)
            SizedBox(
              height: 100,
              child: UnoCardContainer(
                child: UnoCardW(card: widget.state.cards[selectedCard!]),
              ),
            ),
          SizedBox(
            height: 100,
            child: UnoCardListW(
              cards: widget.state.cards,
              axis: Axis.horizontal,
              onPressed: _selectCard,
            ),
          ),
          if (selectedCard != null &&
              isWildcard(widget.state.cards[selectedCard!]))
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
        BuildContext context, UnoPlayerState state) =>
    showDialog(
      context: context,
      builder: (context) => _PlayCardDialog(state: state),
    );

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();
  }

  void _togglePause() {
    setState(() {});
  }

  static int playerId = 0;

  void _addEvent(BuildContext context, UnoClientState state) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          ListTile(
            title: Text("Start Game"),
            onTap: () => widget.client.startGame(),
          ),
          ListTile(
            title: Text("Play Card"),
            onTap: () async {
              final r = await showPlayCardDialog(context, state.player);

              if (r == null) {
                return;
              }
              widget.client.playCard(r.e0, r.e1);
            },
          ),
          ListTile(
            title: Text("Say Uno"),
            onTap: () => widget.client.sayUno(),
          ),
          ListTile(
            title: Text("Add Bot"),
            onTap: () {
              final id = playerId++;
              widget.client.addBot();
            },
          ),
          ListTile(
            title: Text("Draw card"),
            onTap: () => widget.client.drawCard(),
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
        title: Text("Uno"),
      ),
      body: MD3ScaffoldBody.noMargin(
        child: StreamBuilder(
          stream: widget.client.state,
          builder: (context, snap) => snap.hasData
              ? StateW(
                  state: snap.requireData,
                  onPlayCard: widget.client.playCard,
                  onEatCard: widget.client.drawCard,
                )
              : CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: MD3FloatingActionButton.expanded(
        onPressed: () async =>
            _addEvent(context, await widget.client.currentState),
        label: Text('Add event'),
        icon: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
