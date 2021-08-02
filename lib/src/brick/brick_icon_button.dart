import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/inner_shadow/bend_mode.dart';

class BrickIconButton extends StatelessWidget {
  const BrickIconButton({
    Key? key,
    this.onPressed,
    required this.icon,
    this.size = 40.0,
    this.mode = BendMode.CONVEX,
    this.isElevated = false,
    this.isActive = false,
  }) : super(key: key);

  final void Function(Rect? rect)? onPressed;
  final Widget icon;

  final double? size;

  final BendMode mode;

  final bool isElevated;

  final bool isActive;

  bool get isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    Color _bgColor = theme.color.resolveButtonBg(isActive: isActive, isDisabled: onPressed == null);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.color.borderDark),
        boxShadow: false == isElevated
            ? null
            : [
                // TODO replace with theme
                BoxShadow(
                  color: theme.color.shadow,
                  blurRadius: 5,
                  offset: const Offset(1, 1),
                ),
              ],
      ),
      child: ClipOval(
        child: Material(
          color: _bgColor,
          child: BrickInkWell(
            color: _bgColor,
            hoverColor: theme.color.buttonHover,
            onTap: onPressed,
            child: BendContainer(
              mode: mode,
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
    );
  }
}
