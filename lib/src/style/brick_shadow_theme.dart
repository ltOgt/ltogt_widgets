import 'package:flutter/widgets.dart';

/// TODO continue here
/// ,, replace shadows in sortable list
/// ,, replace usage of colors, padding, spacing, ... with BrickTheme
/// ,, get bricktheme from context and fallback on defaults

class BrickShadowTheme {
  final List<BoxShadow> elevated;
  final List<BoxShadow> recessLeft;
  final List<BoxShadow> recessTop;
  final List<BoxShadow> recessRight;
  final List<BoxShadow> recessBottom;

  const BrickShadowTheme({
    required this.elevated,
    required this.recessLeft,
    required this.recessTop,
    required this.recessRight,
    required this.recessBottom,
  });

  static const BrickShadowTheme defaultTheme = _BrickShadowThemeDefaults.theme;

  BrickShadowTheme copyWith({
    List<BoxShadow>? elevated,
    List<BoxShadow>? recessLeft,
    List<BoxShadow>? recessTop,
    List<BoxShadow>? recessRight,
    List<BoxShadow>? recessBottom,
  }) {
    return BrickShadowTheme(
      elevated: elevated ?? this.elevated,
      recessLeft: recessLeft ?? this.recessLeft,
      recessTop: recessTop ?? this.recessTop,
      recessRight: recessRight ?? this.recessRight,
      recessBottom: recessBottom ?? this.recessBottom,
    );
  }
}

class _BrickShadowThemeDefaults {
  const _BrickShadowThemeDefaults._();

  // TODO how to get color from colorTheme in here
  static const shadowColor = Color(0xFF000000);

  static const BrickShadowTheme theme = BrickShadowTheme(
    elevated: [
      BoxShadow(
        color: shadowColor,
        offset: Offset(2, 2),
        spreadRadius: 0,
        blurRadius: 4,
      ),
    ],
    recessLeft: [
      BoxShadow(
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(-1, 0),
        color: shadowColor,
      ),
    ],
    recessRight: [
      BoxShadow(
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(1, 0),
        color: shadowColor,
      ),
    ],
    recessTop: [
      BoxShadow(
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(0, -1),
        color: shadowColor,
      ),
    ],
    recessBottom: [
      BoxShadow(
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(0, 1),
        color: shadowColor,
      ),
    ],
  );
}
