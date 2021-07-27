import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/inner_shadow/bend_mode.dart';

class BrickButton extends StatelessWidget {
  static const BorderRadius defaultBorderRadius = const BorderRadius.all(Radius.circular(8));
  static const EdgeInsets defaultPadding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0);

  BrickButton({
    Key? key,
    this.text,
    this.child,
    this.onPress,
    this.onPressWithRect,
    this.buildMenu,
    this.mode = BendMode.CONVEX,
    this.isElevated = false,
    this.shadowColor = BrickColors.shadow,
    this.bgColor = BrickColors.buttonIdle,
    this.fgColor = BrickColors.buttonTextIdle,
    this.bgColorSelected = BrickColors.buttonHover,
    this.fgColorSelected = BrickColors.buttonTextHover,
    this.bgColorDisabled = BrickColors.buttonDisabled,
    this.fgColorDisabled = BrickColors.buttonTextDisabled,
    this.borderColor = BrickColors.borderDark,
    this.fontSize = 20,
    this.borderRadius = defaultBorderRadius,
    this.border,
    this.padding = defaultPadding,
    this.renderFlat = false,
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

  final String? text;
  final Widget? child;
  final Function()? onPress;
  final Function(Rect r)? onPressWithRect;

  final BendMode mode;
  bool get isConcave => mode == BendMode.CONCAVE;

  final bool isElevated;

  final Color shadowColor;
  final Color bgColor;
  final Color fgColor;
  final Color bgColorSelected;
  @Deprecated("Does not do anything")
  final Color fgColorSelected;
  final Color bgColorDisabled;
  final Color fgColorDisabled;
  final Color borderColor;
  final double? fontSize;

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

  /// Whether to render the button flat instead of bend.
  final bool renderFlat;

  /// Whether to build a floating menu on button click.
  /// The builder is passed the global rect of this button (size and offset on screen).
  /// This rect can be used to position the menu relative to the button.
  final Positioned Function(BuildContext context, Rect globalButtonRect)? buildMenu;

  final GlobalKey globalKey = GlobalKey();

  void onTap(BuildContext context) {
    onPress?.call();

    if (onPressWithRect != null || buildMenu != null) {
      Rect buttonRect = RenderHelper.getRect(globalKey: globalKey)!;

      onPressWithRect?.call(buttonRect);

      if (buildMenu != null) {
        showDialog(
          context: context,
          builder: (context) => Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: const Color(0x22000000),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border ?? Border.all(color: borderColor),
        boxShadow: false == isElevated
            ? null
            : [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 5,
                  offset: const Offset(1, 1),
                ),
              ],
      ),
      child: ConditionalParentWidget(
        condition: borderRadius != null,
        // Can only include clipper for non null border radius
        parentBuilder: (child) => ClipRRect(
          child: child,
          borderRadius: borderRadius!,
        ),
        child: Material(
          key: globalKey,
          color: onPress == null ? bgColorDisabled : bgColor,
          child: InkWell(
            hoverColor: bgColorSelected,
            onTap: (onPress == null && onPressWithRect == null) //
                ? null
                : () => onTap(context),
            child: ConditionalParentWidget(
              condition: false == renderFlat,
              parentBuilder: (child) => BendContainer(
                // THIS widget need borderRadius to be nullable in case of non uniform border
                // But BendContainer will fallback to default on null borderRadius.
                // Instead use BorderRadius.zero to indicate that no border radius is desired
                borderRadius: borderRadius ?? BorderRadius.zero,
                mode: mode,
                child: child,
              ),
              child: Padding(
                padding: padding,
                child: child ??
                    Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: onPress == null ? fgColorDisabled : fgColor,
                        fontSize: fontSize,
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
