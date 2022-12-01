import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:app/color_scheme.dart';
import 'package:app/game_board.dart';
import 'package:app/vector.dart' as vd;
import 'package:flutter/material.dart';
import 'package:kalil_utils/utils.dart';
import 'package:libuno/client.dart';
import 'package:libuno/native/server.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:vector_drawable/vector_drawable.dart' hide Path;
import 'package:vector_math/vector_math_64.dart' hide Vector, Colors;

import '3d_stack.dart';
import 'card.dart';
import 'card_list.dart';
import 'color_select_dialog.dart';

void main() {
  print(File("libuno.so").absolute);
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
    final color = await showColorSelectDialog(context);
    if (color == null) {
      return;
    }
    onPlayCard(i, color);
  }

  Widget _col(BuildContext context) => Column(
        children: [
          if (false)
            PlayStateW(
              state: state.play,
            ),
          Expanded(
            child: GameBoard(
              onEatCard: onEatCard,
              onPlayCard: onPlayCard,
              state: state,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return _col(context);
  }
}

final server = UnoNativeServer();

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
