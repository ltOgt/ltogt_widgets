import 'dart:ui';

class BrickColorTheme {
  /// Color for all types of text.
  final Color text;

  /// Color for all icons
  final Color icon;

  // ============================================================== Background
  /// backest background.
  ///
  /// Used as base color for an empty window.
  final Color background;

  /// mid-background.
  ///
  /// Used for widgets that are placed on the backest background
  /// Same for recessed, elevated or flat.
  final Color background2;

  /// top-background.
  ///
  /// Used for widgets that are placed on the mid-background
  /// Same for recessed, elevated or flat.
  final Color background3;

  // ============================================================== Depth
  /// Color for shadows.
  ///
  /// Used with [BrickElevation]
  final Color shadow;

  /// Edge of a bend widget that faces towards the light.
  final Color bendLight;

  /// Edge of a bend widget that faces away from the light.
  final Color bendDark;

  // ============================================================== Interaction
  /// Used for [BrickInkwell]
  final Color hover;

  /// Used for events that need the users attention.
  /// E.g. errors or confirm exit
  final Color warning;

  /// Used as backdrop for dialoges etc.
  final Color overlayBorderLayer;

  // ============================================================== Border
  /// Border Color (Dark)
  final Color borderDark;

  /// Border Color (Light)
  final Color borderLight;

  // ============================================================== Button
  /// Button that can be clicked.
  /// Shown when no interaction or hovering happens.
  final Color buttonIdle;
  final Color buttonTextIdle;

  /// Button that can not be clicked.
  final Color buttonDisabled;
  final Color buttonTextDisabled;

  /// Button that is hovered over (For Clickable-Buttons)
  final Color buttonHover;
  final Color buttonTextHover;

  /// Button that has been clicked and represents a boolean state.
  final Color buttonActive;
  final Color buttonTextActive;

  BrickColorTheme({
    required this.text,
    required this.icon,
    required this.background,
    required this.background2,
    required this.background3,
    required this.shadow,
    required this.bendLight,
    required this.bendDark,
    required this.hover,
    required this.warning,
    required this.overlayBorderLayer,
    required this.borderDark,
    required this.borderLight,
    required this.buttonIdle,
    required this.buttonTextIdle,
    required this.buttonDisabled,
    required this.buttonTextDisabled,
    required this.buttonHover,
    required this.buttonTextHover,
    required this.buttonActive,
    required this.buttonTextActive,
  });

  static const BrickColorTheme defaultTheme = _BrickColorThemeDefaults();
}

class _BrickColorThemeDefaults implements BrickColorTheme {
  const _BrickColorThemeDefaults();

  static const _white = Color(0xFFFFFFFF);
  static const _grey4 = Color(0xFF444444);
  static const _grey3 = Color(0xFF333333);
  static const _grey2 = Color(0xFF222222);
  static const _grey1 = Color(0xFF111111);
  static const _black = Color(0xFF000000);

  static const _whiteTransparent = Color(0x3DFFFFFF);
  static const _blackTransparent = Color(0x4D000000);

  static const _mutedGreen = Color(0xFF335533);
  static const _red = Color(0xFFFF3333);

  @override
  final Color text = _white;
  @override
  final Color icon = _white;

  @override
  final Color background = _grey4;
  @override
  final Color background2 = _grey2;
  @override
  final Color background3 = _grey1;

  @override
  final Color shadow = _black;
  @override
  final Color bendLight = _whiteTransparent;
  @override
  final Color bendDark = _blackTransparent;

  @override
  final Color hover = _whiteTransparent;
  @override
  final Color warning = _red;
  @override
  final Color overlayBorderLayer = const Color(0x22000000);

  @override
  final Color borderDark = _black;
  @override
  final Color borderLight = _white;

  @override
  final Color buttonIdle = _grey3;
  @override
  final Color buttonTextIdle = _white;
  @override
  final Color buttonDisabled = _black;
  @override
  final Color buttonTextDisabled = _white;
  @override
  final Color buttonHover = _whiteTransparent;
  @override
  final Color buttonTextHover = _white;
  @override
  final Color buttonActive = _mutedGreen;
  @override
  final Color buttonTextActive = _white;
}
