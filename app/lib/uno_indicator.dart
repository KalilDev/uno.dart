import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:material_widgets/material_widgets.dart';

class UnoIndicator extends StatelessWidget {
  const UnoIndicator({
    super.key,
    required this.didUno,
  });
  final bool didUno;

  @override
  Widget build(BuildContext context) {
    return didUno
        ? SizedBox()
        : Material(
            color: Colors.black,
            child: Text(
              "Uno!",
              style: TextStyle(color: Colors.white),
            ),
          );
  }
}
