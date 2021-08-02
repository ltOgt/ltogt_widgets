import 'package:flutter/material.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';
import 'package:ltogt_widgets/src/inner_shadow/bend/box.dart';
import 'package:ltogt_widgets/src/style/brick_theme_provider.dart';

class RecessContainer extends StatelessWidget {
  const RecessContainer({
    Key? key,
    required this.child,
    this.borderRadius = BORDER_RADIUS_ALL_10,
    this.shadowWidth = 10,
  }) : super(key: key);

  final Widget child;
  final BorderRadius? borderRadius;
  final double shadowWidth;

  @override
  Widget build(BuildContext context) {
    final shadowColor = BrickThemeProvider.getTheme(context).color.shadow;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: InnerShadowBox(
        direction: Alignment.topLeft,
        color: shadowColor,
        transitionStartOffset: shadowWidth,
        borderRadius: borderRadius,
        child: InnerShadowBox(
          direction: Alignment.bottomRight,
          color: shadowColor,
          transitionStartOffset: shadowWidth,
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}
