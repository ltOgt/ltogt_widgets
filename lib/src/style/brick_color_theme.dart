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
  final Color borderDark; // TODO ? rename border primary

  /// Border Color (Light)
  final Color borderLight; // TODO ? rename border secondary

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

  const BrickColorTheme({
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

  static const BrickColorTheme defaultTheme = _BrickColorThemeDefaults.theme;

  BrickColorTheme copyWith({
    Color? text,
    Color? icon,
    Color? background,
    Color? background2,
    Color? background3,
    Color? shadow,
    Color? bendLight,
    Color? bendDark,
    Color? hover,
    Color? warning,
    Color? overlayBorderLayer,
    Color? borderDark,
    Color? borderLight,
    Color? buttonIdle,
    Color? buttonTextIdle,
    Color? buttonDisabled,
    Color? buttonTextDisabled,
    Color? buttonHover,
    Color? buttonTextHover,
    Color? buttonActive,
    Color? buttonTextActive,
  }) {
    return BrickColorTheme(
      text: text ?? this.text,
      icon: icon ?? this.icon,
      background: background ?? this.background,
      background2: background2 ?? this.background2,
      background3: background3 ?? this.background3,
      shadow: shadow ?? this.shadow,
      bendLight: bendLight ?? this.bendLight,
      bendDark: bendDark ?? this.bendDark,
      hover: hover ?? this.hover,
      warning: warning ?? this.warning,
      overlayBorderLayer: overlayBorderLayer ?? this.overlayBorderLayer,
      borderDark: borderDark ?? this.borderDark,
      borderLight: borderLight ?? this.borderLight,
      buttonIdle: buttonIdle ?? this.buttonIdle,
      buttonTextIdle: buttonTextIdle ?? this.buttonTextIdle,
      buttonDisabled: buttonDisabled ?? this.buttonDisabled,
      buttonTextDisabled: buttonTextDisabled ?? this.buttonTextDisabled,
      buttonHover: buttonHover ?? this.buttonHover,
      buttonTextHover: buttonTextHover ?? this.buttonTextHover,
      buttonActive: buttonActive ?? this.buttonActive,
      buttonTextActive: buttonTextActive ?? this.buttonTextActive,
    );
  }

  // TODO ? need buttonActiveDisabled too
  Color resolveButtonBg({
    required bool isActive,
    required bool isDisabled,
  }) {
    return isActive ? buttonActive : (isDisabled ? buttonDisabled : buttonIdle);
  }
}

// TODO maybe implementation not the right approach for defaults
// ? instead factory
class _BrickColorThemeDefaults {
  const _BrickColorThemeDefaults._();

  static const _white = Color(0xFFFFFFFF);
  static const _grey5 = Color(0xFF555555);
  static const _grey4 = Color(0xFF444444);
  static const _grey3 = Color(0xFF333333);
  static const _grey2 = Color(0xFF222222);
  static const _grey1 = Color(0xFF111111);
  static const _black = Color(0xFF000000);

  static const _whiteTransparent = Color(0x3DFFFFFF);
  static const _blackTransparent = Color(0x4D000000);

  static const _mutedGreen = Color(0xFF335533);
  static const _red = Color(0xFFFF3333);

  static const BrickColorTheme theme = BrickColorTheme(
    text: _white,
    icon: _white,
    background: _grey4,
    background2: _grey2,
    background3: _grey1,
    shadow: _black,
    bendLight: _whiteTransparent,
    bendDark: _blackTransparent,
    hover: _whiteTransparent,
    warning: _red,
    overlayBorderLayer: Color(0x22000000),
    borderDark: _black,
    borderLight: _grey5,
    buttonIdle: _grey3,
    buttonTextIdle: _white,
    buttonDisabled: _black,
    buttonTextDisabled: _white,
    buttonHover: _whiteTransparent,
    buttonTextHover: _white,
    buttonActive: _mutedGreen,
    buttonTextActive: _white,
  );
}
