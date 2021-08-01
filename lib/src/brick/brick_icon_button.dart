import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/inner_shadow/bend_mode.dart';
import 'package:ltogt_widgets/src/inner_shadow/circle.dart';

class BrickIconButton extends StatelessWidget {
  const BrickIconButton({
    Key? key,
    this.onPressed,
    required this.icon,
    this.size = 40.0,
    this.mode = BendMode.CONVEX,
    this.isElevated = false,
    this.color = BrickColors.buttonIdle,
    this.colorDisabled = BrickColors.buttonDisabled,
    this.hoverColor = BrickColors.buttonHover,
    this.highlightColorLight = BrickColors.highlightColorLight,
    this.highlightColorDark = BrickColors.highlightColorDark,
    this.shadowColor = BrickColors.shadow,
    this.borderColor = BrickColors.borderDark,
  }) : super(key: key);

  final void Function(Rect? rect)? onPressed;
  final Widget icon;

  final double size;
  double get iconSize => size - 10;

  final BendMode mode;
  bool get isConcave => mode == BendMode.CONCAVE;

  final bool isElevated;

  final Color color;
  final Color colorDisabled;
  final Color hoverColor;
  final Color highlightColorLight;
  final Color highlightColorDark;
  final Color shadowColor;
  final Color borderColor;

  bool get isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
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
      child: ClipOval(
        child: Material(
          color: color,
          child: BrickInkWell(
            color: isDisabled ? colorDisabled : color,
            hoverColor: hoverColor,
            onTap: onPressed,
            child: InnerShadowCircle(
              color: highlightColorLight,
              direction: isConcave //
                  ? Alignment.bottomRight
                  : Alignment.topLeft,
              child: InnerShadowCircle(
                color: highlightColorDark,
                direction: isConcave //
                    ? Alignment.topLeft
                    : Alignment.bottomRight,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Center(
                    child: icon,
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
