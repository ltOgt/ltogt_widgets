import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/inner_shadow/bend_mode.dart';

class BrickButton extends StatelessWidget {
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
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  })  : assert(
          child != null || text != null,
          "Must pass either child or text",
        ),
        assert(
          child == null || text == null,
          "Must pass either child or text",
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
  final double fontSize;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

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
        border: Border.all(color: borderColor),
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
      child: ClipRRect(
        key: globalKey,
        borderRadius: borderRadius,
        child: Material(
          color: onPress == null ? bgColorDisabled : bgColor,
          child: InkWell(
            hoverColor: bgColorSelected,
            onTap: (onPress == null && onPressWithRect == null) //
                ? null
                : () => onTap(context),
            child: BendContainer(
              borderRadius: borderRadius,
              mode: mode,
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
