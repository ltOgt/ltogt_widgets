import 'package:flutter/material.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

class BendContainer extends StatelessWidget {
  const BendContainer({
    Key? key,
    required this.child,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.mode = BendMode.CONVEX,
    this.showBorder = false,
  })  : assert(
          borderRadius == null || shape == BoxShape.rectangle,
          "Can not apply borderRadius to Circle",
        ),
        super(key: key);

  /// Only for [shape] `BoxShape.rectangle`
  /// Defaults to [BORDER_RADIUS_ALL_10] for rectangle
  /// Use `BorderRadius.zero` to turn off
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final BendMode mode;
  final Widget child;
  final bool showBorder;

  bool get _isRect => shape == BoxShape.rectangle;
  bool get _isConcave => mode == BendMode.CONCAVE;

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    final darkColor = theme.color.bendDark;
    final lightColor = theme.color.bendLight;

    /// Debugging
    // if (false)
    // return Stack(
    //   children: [
    //     Container(
    //       child: child,
    //       decoration: BoxDecoration(
    //         border: Border.all(color: Colors.blueAccent),
    //         borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
    //       ),
    //     ),
    //     InnerShadowBox(
    //       direction: Alignment.topLeft,
    //       color: _isConcave ? darkColor : lightColor,
    //       borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
    //       child: InnerShadowBox(
    //         direction: Alignment.bottomRight,
    //         color: _isConcave ? lightColor : darkColor,
    //         borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
    //         child: child,
    //       ),
    //     )
    //   ],
    // );

    // null for circle
    BorderRadius? _radius;

    if (_isRect) {
      // Needs to be `BorderRadius.zero` for ~null
      _radius = borderRadius ?? BORDER_RADIUS_ALL_10;
    }

    final content = _isRect //
        ? ClipRRect(
            borderRadius: _radius!,
            child: InnerShadowBox(
              direction: Alignment.topLeft,
              color: _isConcave ? darkColor : lightColor,
              borderRadius: _radius,
              child: InnerShadowBox(
                direction: Alignment.bottomRight,
                color: _isConcave ? lightColor : darkColor,
                borderRadius: _radius,
                child: child,
              ),
            ),
          )
        : ClipOval(
            child: InnerShadowCircle(
              direction: Alignment.topLeft,
              color: _isConcave ? darkColor : lightColor,
              child: InnerShadowCircle(
                direction: Alignment.bottomRight,
                color: _isConcave ? lightColor : darkColor,
                child: child,
              ),
            ),
          );

    if (false == showBorder) {
      return content;
    }

    return DecoratedBox(
      child: content,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: _radius,
        border: Border.all(color: theme.color.borderDark),
      ),
    );
  }
}
