import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/inner_shadow/bend/bend_mode.dart';
import 'package:ltogt_widgets/src/style/brick_theme_provider.dart';

class BrickButton extends StatelessWidget {
  static const BorderRadius defaultBorderRadius = const BorderRadius.all(Radius.circular(8));
  static const EdgeInsets defaultPadding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0);

  BrickButton({
    Key? key,
    this.text,
    this.fontSize,
    this.child,
    this.onPress,
    this.onPressWithRect,
    this.buildMenu,
    this.isActive = false,
    this.mode = BendMode.CONVEX,
    this.renderFlat = false,
    this.isElevated = false,
    this.borderRadius = defaultBorderRadius,
    this.border,
    this.padding = defaultPadding,
  })  : assert(
          child != null || text != null,
          "Must pass either child or text",
        ),
        assert(
          child == null || text == null,
          "Must pass either child or text",
        ),
        assert(
          border == null || border.isUniform || borderRadius == null,
          "Can only supply borderRadius for uniform border",
        ),
        super(key: key);

  /// Build a button with this text.
  /// [child] must be null if this is non-null.
  final String? text;

  /// The font size to use for [text].
  /// Useless if [text] is null.
  final double? fontSize;

  /// Build a button with this child.
  /// [text] must be null if this is non-null.
  final Widget? child;

  /// Called when button is pressed
  final Function()? onPress;

  /// Called when button is pressed
  final Function(Rect r)? onPressWithRect;

  /// Whether to build a floating menu on button click.
  /// The builder is passed the global rect of this button (size and offset on screen).
  /// This rect can be used to position the menu relative to the button.
  final Positioned Function(BuildContext context, Rect globalButtonRect)? buildMenu;

  /// Sets [mode] to [BendMode.CONCAVE] and color to [BrickColorTheme()..buttonActive]
  /// Overrides [mode] parameter.
  // TODO might want to have convex active buttons... if ever comes up set mode to nullable and only set to concave if null.
  final bool isActive;

  /// Whether the button should be [BendMode.CONCAVE] or [BendMode.CONVEX]
  final BendMode mode;
  bool get isConcave => mode == BendMode.CONCAVE;

  /// Whether to render the button flat instead of bend.
  final bool renderFlat;

  /// Whether to add a shadow to imitate elevation.
  final bool isElevated;

  /// Radius to apply to uniform [border].
  /// If [border] is not uniform, this must be null.
  /// Defaults to [defaultBorderRadius].
  final BorderRadius? borderRadius;

  /// If this is null, [borderColor] is applied to a default border with width 1.
  /// Otherwise [borderColor] has no effect and this [border] is applied directly.
  final Border? border;

  /// Padding that is applied to the content inside the bounds of the button.
  /// Defaults to [defaultPadding]
  final EdgeInsets padding;

  /// Needed to get the rect of the button for callbacks [buildMenu] and [onPressWithRect]
  final GlobalKey _globalKeyForButtonRect = GlobalKey();

  void onTap(BuildContext context) {
    onPress?.call();

    if (onPressWithRect != null || buildMenu != null) {
      Rect buttonRect = RenderHelper.getRect(globalKey: _globalKeyForButtonRect)!;

      onPressWithRect?.call(buttonRect);

      if (buildMenu != null) {
        final theme = BrickThemeProvider.getTheme(context);

        showDialog(
          context: context,
          builder: (context) => Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: theme.color.overlayBorderLayer,
                ),
              ),
              buildMenu!.call(context, buttonRect),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    bool _isDisabled = (onPress == null && onPressWithRect == null);

    BendMode _mode = isActive ? BendMode.CONCAVE : mode;

    Color _bgColor = theme.color.resolveButtonBg(isActive: isActive, isDisabled: _isDisabled);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border ?? Border.all(color: theme.color.borderDark),
        boxShadow: false == isElevated
            ? null
            : [
                BoxShadow(
                  color: theme.color.shadow,
                  blurRadius: 5,
                  offset: const Offset(1, 1),
                ),
              ],
      ),
      child: ConditionalParentWidget(
        condition: borderRadius != null,
        // Can only include clipper for non null border radius
        parentBuilder: (_child) => ClipRRect(
          child: _child,
          borderRadius: borderRadius!,
        ),
        child: Material(
          key: _globalKeyForButtonRect,
          color: _bgColor,
          child: InkWell(
            hoverColor: theme.color.buttonHover,
            onTap: _isDisabled //
                ? null
                : () => onTap(context),
            child: ConditionalParentWidget(
              condition: false == renderFlat,
              parentBuilder: (child) => BendContainer(
                // THIS widget need borderRadius to be nullable in case of non uniform border
                // But BendContainer will fallback to default on null borderRadius.
                // Instead use BorderRadius.zero to indicate that no border radius is desired
                borderRadius: borderRadius ?? BorderRadius.zero,
                mode: _mode,
                child: child,
              ),
              child: Padding(
                padding: padding,
                child: Center(
                  child: child ??
                      Text(
                        text!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isDisabled ? theme.color.buttonTextDisabled : theme.color.buttonTextIdle,
                          fontSize: fontSize,
                        ),
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
