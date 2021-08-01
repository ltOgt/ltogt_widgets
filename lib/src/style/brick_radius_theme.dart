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

  static const BrickRadiusTheme defaultTheme = _BrickRadiusThemeDefaults();
}

class _BrickRadiusThemeDefaults implements BrickRadiusTheme {
  const _BrickRadiusThemeDefaults();

  @override
  final BorderRadius small = const BorderRadius.all(Radius.circular(5.0));
  @override
  final BorderRadius medium = const BorderRadius.all(Radius.circular(10.0));
  @override
  final BorderRadius large = const BorderRadius.all(Radius.circular(15.0));
}
