import 'package:flutter/widgets.dart';

class BrickRadiusTheme {
  final BorderRadius small;
  final BorderRadius medium;
  final BorderRadius large;

  const BrickRadiusTheme({
    required this.small,
    required this.medium,
    required this.large,
  });

  static const BrickRadiusTheme defaultTheme = _BrickRadiusThemeDefaults.theme;

  BrickRadiusTheme copyWith({
    BorderRadius? small,
    BorderRadius? medium,
    BorderRadius? large,
  }) {
    return BrickRadiusTheme(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
    );
  }
}

class _BrickRadiusThemeDefaults {
  const _BrickRadiusThemeDefaults._();

  static const BrickRadiusTheme theme = BrickRadiusTheme(
    small: BorderRadius.all(Radius.circular(5.0)),
    medium: BorderRadius.all(Radius.circular(10.0)),
    large: BorderRadius.all(Radius.circular(15.0)),
  );
}
