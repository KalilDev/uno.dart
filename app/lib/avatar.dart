import 'package:app/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.name,
    required this.id,
  });

  final String name;
  final UnoPlayerId id;

  @override
  Widget build(BuildContext context) {
    final CustomColorScheme color;
    switch (int.parse(id.unwrap)) {
      case 0:
        color = context.appColorScheme.blue;
        break;
      case 1:
        color = context.appColorScheme.green;
        break;
      case 2:
        color = context.appColorScheme.red;
        break;
      case 3:
        color = context.appColorScheme.yellow;
        break;
      default:
        throw UnimplementedError();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          type: MaterialType.circle,
          color: color.colorContainer,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconTheme.merge(
              data: IconThemeData(
                opacity: 1,
                size: 50,
                color: color.onColorContainer,
              ),
              child: Icon(Icons.person_outline),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(name)
      ],
    );
  }
}
