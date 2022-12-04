import 'package:app/uno_indicator.dart';
import 'package:flutter/material.dart';
import 'package:libuno/client.dart';
import 'package:material_widgets/material_widgets.dart';

import 'avatar.dart';
import 'card_list.dart';

enum OpponentPosition {
  top,
  left,
  right,
}

extension on OpponentPosition {
  bool get isVertical {
    switch (this) {
      case OpponentPosition.top:
        return false;
      case OpponentPosition.left:
        return true;
      case OpponentPosition.right:
        return true;
    }
  }
}

class OpponentW extends StatelessWidget {
  const OpponentW({
    super.key,
    required this.state,
    required this.position,
    required this.isPlaying,
  });
  final PlayerClientState state;
  final OpponentPosition position;
  final bool isPlaying;

  Widget _card(
    BuildContext context, {
    required CardStyle style,
    required Widget child,
  }) {
    style = style.copyWith(padding: MaterialStateProperty.all(EdgeInsets.zero));
    return isPlaying
        ? FilledCard(
            style: style,
            child: child,
          )
        : ElevatedCard(
            style: style,
            child: child,
          );
  }

  List<Widget> _children(BuildContext context) => [
        Center(
          child: Avatar(
            name: state.name,
            id: state.id,
          ),
        ),
        SizedBox.square(
          dimension: context.sizeClass.minimumMargins / 2,
        ),
        UnoIndicator(
          didUno: state.didUno,
          isVertical: position.isVertical,
        ),
        UnoBackCardListW(
          cards: state.cardCount,
          axis: position.isVertical ? Axis.vertical : Axis.horizontal,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius;
    const radius = Radius.circular(24.0);
    switch (position) {
      case OpponentPosition.top:
        borderRadius =
            BorderRadius.only(bottomLeft: radius, bottomRight: radius);
        break;
      case OpponentPosition.left:
        borderRadius = BorderRadius.only(bottomRight: radius, topRight: radius);
        break;
      case OpponentPosition.right:
        borderRadius = BorderRadius.only(bottomLeft: radius, topLeft: radius);
        break;
    }
    final style = CardStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      elevation: MaterialStateProperty.all(
        isPlaying ? context.elevation.level3 : context.elevation.level1,
      ),
      padding: MaterialStateProperty.all(
        position.isVertical
            ? EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 16,
              )
            : EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
      ),
    );
    return _card(
      context,
      style: style,
      child: ListView(
        primary: false,
        scrollDirection: position.isVertical ? Axis.vertical : Axis.horizontal,
        padding: style.padding!.resolve({}),
        children: _children(context),
      ),
    );
  }
}
