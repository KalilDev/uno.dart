import 'package:app/3d_stack.dart';
import 'package:app/card.dart';
import 'package:flutter/material.dart';
import 'package:libuno/uno.dart';
import 'package:vector_math/vector_math_64.dart';

import 'card_aspect_ratio.dart';

class BackUnoCardStackW extends StatelessWidget {
  const BackUnoCardStackW({
    super.key,
    required this.cards,
    this.onPressed,
    this.stackDirection,
  });
  final int cards;
  final VoidCallback? onPressed;
  final Vector2? stackDirection;

  @override
  Widget build(BuildContext context) => CardAspectRatio(
        child: AnimatedStack3D(
          itemBuilder: (context, i) => UnoBackCardW(
            onPressed: onPressed == null || i != cards - 1 ? null : onPressed!,
          ),
          itemCount: cards,
        ),
      );
}

class UnoCardStackW extends StatelessWidget {
  const UnoCardStackW({
    super.key,
    required this.cards,
    this.onPressed,
  });
  final UnoCards cards;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => CardAspectRatio(
        child: AnimatedStack3D(
          itemBuilder: (context, i) => UnoCardW(
            card: cards.elementAt(i),
            onPressed:
                onPressed == null || i != cards.length - 1 ? null : onPressed!,
          ),
          itemCount: cards.length,
          itemSeparation: 1,
        ),
      );
}
