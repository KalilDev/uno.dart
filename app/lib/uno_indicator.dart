import 'package:app/vector.dart' as vd;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:vector_drawable/vector_drawable.dart';

class UnoIndicator extends StatelessWidget {
  const UnoIndicator({
    super.key,
    required this.didUno,
    required this.isVertical,
  });
  final bool didUno;
  final bool isVertical;

  Widget _rowOrColumn(
    BuildContext context, {
    required Widget child,
  }) {
    final children = [
      Expanded(child: SizedBox()),
      child,
      Expanded(child: SizedBox())
    ];
    return isVertical
        ? Row(
            children: children,
          )
        : Column(
            children: children,
          );
  }

  @override
  Widget build(BuildContext context) {
    final gutter = context.sizeClass.minimumMargins / 2;
    return !didUno
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(
              bottom: isVertical ? gutter : 0,
              right: !isVertical ? gutter : 0,
            ),
            child: _rowOrColumn(
              context,
              child: Material(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(5.7),
                  child: RawVectorWidget(
                    vector: vd.logo.body,
                    styleMapping: vd.defaultStyleMapping,
                  ),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
  }
}
