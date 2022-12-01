import 'package:app/card_aspect_ratio.dart';
import 'package:app/opponent.dart';
import 'package:app/player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:libuno/client.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';

import 'card_stack.dart';

class _GameBoardCenter extends StatelessWidget {
  const _GameBoardCenter({
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: CardWrapper(
              child: UnoCardStackW(
                cards: playedCards,
                onPressed: onPlayedCards,
              ),
            ),
          ),
        ),
        SizedBox(width: context.sizeClass.minimumMargins),
        Expanded(
          child: Center(
            child: CardWrapper(
              child: BackUnoCardStackW(
                cards: cardStackLength,
                onPressed: onCardStack,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
    required this.state,
    required this.onEatCard,
    required this.onPlayCard,
  });
  final UnoClientState state;
  final VoidCallback onEatCard;
  final void Function(int, [UnoCardColor?]) onPlayCard;
  static const opponentFactor = 1.5;
  static const opponentHeight = 100.0 * opponentFactor;
  static const opponentWidth = 70.4545454545454545 * opponentFactor;
  static const playerHeight = 200.0;
  static const smallPadding = 16.0;
  static const largePadding = 24.0;
  Widget _player(BuildContext context, bool isPlaying) => PlayerW(
        state: state.player,
        isPlaying: isPlaying,
        onCard: onPlayCard,
      );
  Widget _center(BuildContext context, bool isPlaying) => _GameBoardCenter(
        playedCards: state.playedCards,
        cardStackLength: state.cardStackLength,
        onCardStack: state.play.visit(
          unoPlaying: (playing) => isPlaying ? onEatCard : null,
          unoWaitingStart: (_) => null,
          unoFinished: (_) => null,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final currentPlayer = state.play.visit(
      unoFinished: (f) => f.winner,
      unoPlaying: (p) => p.currentPlayer,
      unoWaitingStart: (_) => null,
    );
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: opponentHeight + smallPadding,
          bottom: playerHeight + largePadding,
          child: SizedBox(
            width: opponentWidth,
            child: OpponentW(
              state: state.players[UnoPlayerId("1")]!,
              position: OpponentPosition.left,
              isPlaying: currentPlayer == UnoPlayerId("1"),
            ),
          ),
        ),
        Positioned(
          left: opponentWidth + smallPadding,
          right: opponentWidth + smallPadding,
          top: 0,
          child: SizedBox(
            height: opponentHeight,
            child: OpponentW(
              state: state.players[UnoPlayerId("2")]!,
              position: OpponentPosition.top,
              isPlaying: currentPlayer == UnoPlayerId("2"),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: opponentHeight + smallPadding,
          bottom: playerHeight + largePadding,
          child: SizedBox(
            width: opponentWidth,
            child: OpponentW(
              state: state.players[UnoPlayerId("3")]!,
              position: OpponentPosition.right,
              isPlaying: currentPlayer == UnoPlayerId("3"),
            ),
          ),
        ),
        Positioned(
          left: opponentWidth + smallPadding,
          right: opponentWidth + smallPadding,
          top: opponentHeight + smallPadding,
          bottom: playerHeight + largePadding,
          child: _center(context, currentPlayer == state.player.id),
        ),
        if (false)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: playerHeight,
              child: _player(context, currentPlayer == state.player.id),
            ),
          ),
      ],
    );
  }
}
