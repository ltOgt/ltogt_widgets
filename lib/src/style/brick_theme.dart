import 'package:flutter/material.dart';
import 'package:ltogt_widgets/src/style/brick_color_theme.dart';
import 'package:ltogt_widgets/src/style/brick_radius_theme.dart';
import 'package:ltogt_widgets/src/style/brick_shadow_theme.dart';

class BrickTheme {
  final BrickColorTheme color;
  final BrickShadowTheme shadow;
  final BrickRadiusTheme radius;
  //final BrickPaddingTheme padding;
  //final BrickSpacingTheme spacing;
  //final BrickTextTheme textStyle;

  const BrickTheme({
    required this.color,
    required this.shadow,
    required this.radius,
  });

  static const BrickTheme defaultTheme = BrickTheme(
    color: BrickColorTheme.defaultTheme,
    shadow: BrickShadowTheme.defaultTheme,
    radius: BrickRadiusTheme.defaultTheme,
  );

  ThemeData get themeData {
    ThemeData darkThemeDefaults = ThemeData.dark();

    Color txtColor = color.text;

    // TODO adjust this later
    ColorScheme colorScheme = ColorScheme(
        brightness: Brightness.dark,
        primary: color.background2,
        primaryVariant: color.background2,
        secondary: color.background2,
        secondaryVariant: color.background2,
        background: color.background,
        surface: color.background2,
        onBackground: txtColor,
        onSurface: txtColor,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        error: color.warning);

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    return ThemeData.from(textTheme: darkThemeDefaults.textTheme, colorScheme: colorScheme);
    //..copyWith(buttonColor: accent1, cursorColor: accent1, highlightColor: accent1, toggleableActiveColor: accent1);
  }
}
