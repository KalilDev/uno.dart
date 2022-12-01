import 'package:app/card_aspect_ratio.dart';
import 'package:app/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:kalil_utils/utils.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:vector_drawable/vector_drawable.dart' hide Path;
import 'vector.dart' as vd;

class _CardShadowDecorationPainter extends BoxPainter {
  const _CardShadowDecorationPainter(this.elevation);
  final double elevation;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final path = CardShape().getOuterPath(offset & configuration.size!);
    canvas.drawShadow(path, Colors.black, 3, false);
  }
}

class _CardShadowDecoration extends Decoration {
  const _CardShadowDecoration({this.elevation = 3});
  final double elevation;
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _CardShadowDecorationPainter(elevation);
}

Map<String, Color> _styleMappings() => {
      "background": vd.blackC,
      "foreground": vd.whiteC,
      "green": vd.greenC,
      "yellow": vd.yellowC,
      "blue": vd.blueC,
      "red": vd.redC,
    };

Map<String, Color> _md3StyleMappingsFromScheme(UnoAppColorScheme colors) => {
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
    this.elevation = 3,
  });
  final UnoCard card;
  final VoidCallback? onPressed;
  final double elevation;

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
        ..._styleMappings(),
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
        ..._md3StyleMappingsFromScheme(colors),
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
    this.elevation = 3,
  });
  final VoidCallback? onPressed;
  final VectorDrawable vector;
  final StyleResolver styleResolver;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final w = CardAspectRatio(
      child: DecoratedBox(
        decoration: _CardShadowDecoration(elevation: elevation),
        child: RawVectorWidget(
          vector: vector.body,
          styleMapping: styleResolver,
        ),
      ),
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

class UnoBackCardW extends StatelessWidget {
  const UnoBackCardW({
    super.key,
    this.onPressed,
    this.elevation = 3,
  });
  final VoidCallback? onPressed;
  final double elevation;

  @override
  Widget build(BuildContext context) => PressableCard(
        vector: vd.back,
        styleResolver: vd.defaultStyleMapping,
        onPressed: onPressed,
        elevation: elevation,
      );
}
