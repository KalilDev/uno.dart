import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';

extension AppSchemeAndThemeE on BuildContext {
  UnoAppColorTheme get appColorTheme =>
      InheritedAppCustomColorTheme.maybeOf<UnoAppColorScheme, UnoAppColorTheme>(
          this)!;
  UnoAppColorScheme get appColorScheme =>
      InheritedAppCustomColorScheme.maybeOf<UnoAppColorScheme>(this)!;
}

class UnoAppColorScheme extends AppCustomColorScheme<UnoAppColorScheme> {
  final CustomColorScheme green;
  final CustomColorScheme blue;
  final CustomColorScheme yellow;
  final CustomColorScheme red;
  final CustomColorScheme black;

  UnoAppColorScheme({
    required this.green,
    required this.blue,
    required this.yellow,
    required this.red,
    required this.black,
  });

  @override
  UnoAppColorScheme lerpWith(UnoAppColorScheme b, double t) => lerp(this, b, t);

  static UnoAppColorScheme lerp(
    UnoAppColorScheme a,
    UnoAppColorScheme b,
    double t,
  ) {
    return UnoAppColorScheme(
      green: CustomColorScheme.lerp(a.green, b.green, t),
      blue: CustomColorScheme.lerp(a.blue, b.blue, t),
      yellow: CustomColorScheme.lerp(a.yellow, b.yellow, t),
      red: CustomColorScheme.lerp(a.red, b.red, t),
      black: CustomColorScheme.lerp(a.black, b.black, t),
    );
  }

  int get hashCode => Object.hashAll([
        green,
        blue,
        yellow,
        red,
        black,
      ]);

  bool operator ==(dynamic other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! UnoAppColorScheme) {
      return false;
    }
    return green == other.green &&
        blue == other.blue &&
        yellow == other.yellow &&
        red == other.red &&
        black == other.black;
  }
}

class UnoAppColorTheme
    extends AppCustomColorTheme<UnoAppColorScheme, UnoAppColorTheme> {
  final CustomColorTheme green;
  final CustomColorTheme blue;
  final CustomColorTheme yellow;
  final CustomColorTheme red;
  final CustomColorTheme black;

  static Color greenSeed = Color(0xFF2c5835);
  static Color blueSeed = Color(0xFF376096);
  static Color yellowSeed = Color(0xFFe9db44);
  static Color redSeed = Color(0xFFd03b41);
  static Color blackSeed = Color(0xFF000000);

  UnoAppColorTheme({
    required this.green,
    required this.blue,
    required this.yellow,
    required this.red,
    required this.black,
  });

  static UnoAppColorTheme fromMonetTheme(MonetTheme t) => UnoAppColorTheme(
        green: t.harmonizedCustomColorTheme(greenSeed),
        blue: t.harmonizedCustomColorTheme(blueSeed),
        yellow: t.harmonizedCustomColorTheme(yellowSeed),
        red: t.harmonizedCustomColorTheme(redSeed),
        black: t.harmonizedCustomColorTheme(blackSeed),
      );

  @override
  UnoAppColorScheme get dark => UnoAppColorScheme(
        green: green.dark,
        blue: blue.dark,
        yellow: yellow.dark,
        red: red.dark,
        black: black.dark,
      );

  @override
  UnoAppColorTheme lerpWith(UnoAppColorTheme b, double t) => lerp(this, b, t);

  static UnoAppColorTheme lerp(
    UnoAppColorTheme a,
    UnoAppColorTheme b,
    double t,
  ) {
    return UnoAppColorTheme(
      green: CustomColorTheme.lerp(a.green, b.green, t),
      blue: CustomColorTheme.lerp(a.blue, b.blue, t),
      yellow: CustomColorTheme.lerp(a.yellow, b.yellow, t),
      red: CustomColorTheme.lerp(a.red, b.red, t),
      black: CustomColorTheme.lerp(a.black, b.black, t),
    );
  }

  @override
  UnoAppColorScheme get light => UnoAppColorScheme(
        green: green.light,
        blue: blue.light,
        yellow: yellow.light,
        red: red.light,
        black: black.light,
      );

  int get hashCode => Object.hashAll([
        green,
        blue,
        yellow,
        red,
        black,
      ]);

  bool operator ==(dynamic other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! UnoAppColorTheme) {
      return false;
    }
    return green == other.green &&
        blue == other.blue &&
        yellow == other.yellow &&
        red == other.red &&
        black == other.black;
  }
}
