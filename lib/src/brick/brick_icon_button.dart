import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/inner_shadow/bend/bend_mode.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        // : If height is constrained tighter than width, set height to size for aspect ratio to orient it self by
        // _ this size might not be met, but by setting the larger dimension to null instead of size, it is ensured that the widget does not become an oval
        height: constraints.maxHeight <= constraints.maxWidth ? size : null,
        width: constraints.maxHeight >= constraints.maxWidth ? size : null,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            // : Attempt to make both fixed to size, see above if size does not fit
            width: size,
            height: size,
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
              child: BrickInkWell(
                color: _bgColor,
                hoverColor: theme.color.buttonHover,
                onTap: onPressed,
                child: BendContainer(
                  shape: BoxShape.circle,
                  mode: isActive ? BendMode.CONCAVE : mode,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: icon,
                      ),
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
