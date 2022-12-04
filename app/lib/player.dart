import 'package:app/avatar.dart';
import 'package:app/uno_indicator.dart';
import 'package:flutter/material.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';

import 'card_list.dart';

class PlayerW extends StatelessWidget {
  const PlayerW({
    super.key,
    required this.state,
    required this.isPlaying,
    this.onCard,
  });
  final UnoPlayerState state;
  final bool isPlaying;
  final ValueChanged<int>? onCard;

  List<Widget> _children(BuildContext context) => [
        Center(child: Avatar(name: state.name, id: state.id)),
        SizedBox.square(
          dimension: context.sizeClass.minimumMargins / 2,
        ),
        UnoIndicator(
          didUno: state.didUno,
          isVertical: false,
        ),
        UnoCardListW(
          cards: state.cards,
          axis: Axis.horizontal,
          onPressed: onCard,
        ),
      ];

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

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(24.0);
    final borderRadius = BorderRadius.vertical(top: radius);
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
        EdgeInsets.symmetric(
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
        scrollDirection: Axis.horizontal,
        padding: style.padding!.resolve({}),
        children: _children(context),
      ),
    );
  }
}
