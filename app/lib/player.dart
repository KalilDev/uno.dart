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

  Widget _row(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Avatar(name: state.name, id: state.id),
            UnoIndicator(didUno: state.didUno),
            UnoCardListW(
              cards: state.cards,
              axis: Axis.horizontal,
              onPressed: onCard,
            ),
          ],
        ),
      );

  Widget _card(
    BuildContext context, {
    required CardStyle style,
    required Widget child,
  }) {
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
      child: _row(context),
    );
  }
}
