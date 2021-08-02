import 'package:flutter/material.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

class BendContainer extends StatelessWidget {
  const BendContainer({
    Key? key,
    required this.child,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.mode = BendMode.CONVEX,
  })  : assert(
          borderRadius == null || shape == BoxShape.rectangle,
          "Can not apply borderRadius to Circle",
        ),
        super(key: key);

  /// Only for [shape] `BoxShape.rectangle`
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final BendMode mode;
  final Widget child;

  bool get _isRect => shape == BoxShape.rectangle;
  bool get _isConcave => mode == BendMode.CONCAVE;

  @override
  Widget build(BuildContext context) {
    final theme = BrickThemeProvider.getTheme(context);

    final darkColor = theme.color.bendDark;
    final lightColor = theme.color.bendLight;

    if (false)
      return Stack(
        children: [
          Container(
            child: child,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
            ),
          ),
          InnerShadowBox(
            direction: Alignment.topLeft,
            color: _isConcave ? darkColor : lightColor,
            borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
            child: InnerShadowBox(
              direction: Alignment.bottomRight,
              color: _isConcave ? lightColor : darkColor,
              borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
              child: child,
            ),
          )
        ],
      );

    return _isRect //
        ? ClipRRect(
            borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
            child: InnerShadowBox(
              direction: Alignment.topLeft,
              color: _isConcave ? darkColor : lightColor,
              borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
              child: InnerShadowBox(
                direction: Alignment.bottomRight,
                color: _isConcave ? lightColor : darkColor,
                borderRadius: borderRadius ?? BORDER_RADIUS_ALL_10,
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
  }
}
