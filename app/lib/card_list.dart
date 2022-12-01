import 'package:app/card_aspect_ratio.dart';
import 'package:flutter/material.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';

import 'card.dart';

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

  Widget _buildCard(BuildContext context, int i) => UnoCardW(
        card: cards[i],
        onPressed: onPressed == null ? null : () => onPressed!.call(i),
      );
  Iterable<Widget> children(BuildContext context) sync* {
    var isFirst = true;
    final sep = SizedBox.square(
      dimension: context.sizeClass.minimumMargins / 2,
    );
    for (var i = 0; i < cards.length; i++) {
      if (!isFirst) {
        yield sep;
      }
      isFirst = false;
      yield _buildCard(context, i);
    }
  }

  @override
  Widget build(BuildContext context) => axis == Axis.vertical
      ? Column(
          mainAxisSize: MainAxisSize.min,
          children: children(context).toList(),
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: children(context).toList(),
        );
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

  Widget _buildBackCard(BuildContext context, int i) => CardWrapper(
        byHeight: axis == Axis.horizontal,
        child: UnoBackCardW(
          onPressed: onPressed == null ? null : () => onPressed!.call(i),
        ),
      );

  Iterable<Widget> children(BuildContext context) sync* {
    var isFirst = true;
    final sep = SizedBox.square(
      dimension: context.sizeClass.minimumMargins / 2,
    );
    for (var i = 0; i < cards; i++) {
      if (!isFirst) {
        yield sep;
      }
      isFirst = false;
      yield _buildBackCard(context, i);
    }
  }

  @override
  Widget build(BuildContext context) => axis == Axis.vertical
      ? Column(
          mainAxisSize: MainAxisSize.min,
          children: children(context).toList(),
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: children(context).toList(),
        );
}
