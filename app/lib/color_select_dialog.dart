import 'package:app/color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:libuno/uno.dart';
import 'package:material_widgets/material_widgets.dart';

Future<UnoCardColor?> showColorSelectDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => _ColorSelectDialog(),
    );

class _ColorSelectDialog extends StatelessWidget {
  const _ColorSelectDialog({super.key});

  @override
  Widget build(BuildContext context) => MD3BasicDialog(
        title: Text('Selecionar Cor'),
        content: Column(
          children: [
            _ColorSelectDialogTile(
              colorScheme: context.appColorScheme.green,
              unoColor: UnoCardColor.green,
              child: Text('Verde'),
            ),
            _ColorSelectDialogTile(
              colorScheme: context.appColorScheme.blue,
              unoColor: UnoCardColor.blue,
              child: Text('Azul'),
            ),
            _ColorSelectDialogTile(
              colorScheme: context.appColorScheme.red,
              unoColor: UnoCardColor.red,
              child: Text('Vermelho'),
            ),
            _ColorSelectDialogTile(
              colorScheme: context.appColorScheme.yellow,
              unoColor: UnoCardColor.yellow,
              child: Text('Amarelo'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'))
        ],
      );
}

class _ColorSelectDialogTile extends StatelessWidget {
  const _ColorSelectDialogTile({
    Key? key,
    required this.colorScheme,
    required this.unoColor,
    required this.child,
  }) : super(key: key);
  final CustomColorScheme colorScheme;
  final UnoCardColor unoColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorScheme.colorContainer,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => Navigator.of(context).pop(UnoCardColor.green),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: DefaultTextStyle.merge(
              child: SizedBox(width: double.infinity, child: child),
              style: TextStyle(color: colorScheme.onColorContainer)),
        ),
      ),
    );
  }
}
