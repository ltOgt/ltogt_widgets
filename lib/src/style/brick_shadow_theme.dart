import 'package:flutter/widgets.dart';

/// TODO continue here
/// ,, replace shadows in sortable list
/// ,, replace usage of colors, padding, spacing, ... with BrickTheme
/// ,, get bricktheme from context and fallback on defaults

class BrickShadowTheme {
  final List<BoxShadow> elevated;
  //final List<BoxShadow> recessLeft;
  //final List<BoxShadow> recessTop;
  //final List<BoxShadow> recessRight;
  //final List<BoxShadow> recessBottom;

  const BrickShadowTheme({
    required this.elevated,
  });

  static const BrickShadowTheme defaultTheme = _BrickShadowThemeDefaults.theme;

  BrickShadowTheme copyWith({
    List<BoxShadow>? elevated,
  }) {
    return BrickShadowTheme(
      elevated: elevated ?? this.elevated,
    );
  }
}

class _BrickShadowThemeDefaults {
  const _BrickShadowThemeDefaults._();

  static const BrickShadowTheme theme = BrickShadowTheme(
    elevated: [
      BoxShadow(
        color: Color(0xFF000000),
        offset: Offset(2, 2),
        spreadRadius: 0,
        blurRadius: 4,
      ),
    ],
  );
}
