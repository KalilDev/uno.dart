import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class Stack3D extends StatelessWidget {
  const Stack3D({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.itemSeparation = 0.5,
    this.direction,
  });
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemSeparation;
  final Vector2? direction;

  @override
  Widget build(BuildContext context) {
    final d = direction ?? Vector2(1, 1);
    final h = (d.x + 1) / 2;
    final v = (d.y + 1) / 2;
    double at(int i, double t) =>
        lerpDouble(i * itemSeparation, (itemCount - i) * itemSeparation, t)!;
    return Stack(
      children: [
        for (var i = 0; i < itemCount; i++)
          Positioned(
            right: at(i, 1 - h),
            top: at(i, 1 - v),
            bottom: at(i, v),
            left: at(i, h),
            child: itemBuilder(context, i),
          )
      ],
    );
  }
}

class AnimatedStack3D extends StatefulWidget {
  const AnimatedStack3D({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.itemSeparation = 0.5,
    this.initialDirection,
  });
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemSeparation;
  final Vector2? initialDirection;

  @override
  State<AnimatedStack3D> createState() => _AnimatedStack3DState();
}

class _AnimatedStack3DState extends State<AnimatedStack3D> {
  late Vector2 direction;
  Vector2 center = Vector2(0, 0);
  double factor = 1;
  void initState() {
    super.initState();
    direction = widget.initialDirection ?? Vector2(1, 1);
  }

  void _onHover(PointerHoverEvent e) {
    final renderBox = context.findRenderObject() as RenderBox;
    final rect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    // print(rect);
    // print(e.position);
    // print(rect.center);
    final distanceToCenter = (rect.center - e.position).distance;
    // print(distanceToCenter);
    final centerLength = (rect.center - rect.topLeft).distance;
    //print(centerLength);
    //factor = distanceToCenter / centerLength;
    Offset norm(Offset a) => a / a.distance;
    center = Vector2(
      -norm(e.position - rect.center).dx,
      norm(e.position - rect.center).dy,
    );
    factor = 0;
    setState(() {});
  }

  void _onExit(PointerExitEvent e) {
    factor = 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
        onHover: _onHover,
        hitTestBehavior: HitTestBehavior.opaque,
        onExit: _onExit,
        child: TweenAnimationBuilder(
            tween: Tween(end: factor),
            duration: Duration(milliseconds: 300),
            builder: (context, factor, _) => Stack3D(
                  itemBuilder: widget.itemBuilder,
                  itemCount: widget.itemCount,
                  itemSeparation: widget.itemSeparation,
                  direction: center + (direction - center) * factor,
                )),
      );
}
