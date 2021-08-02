import 'dart:math';

import 'package:flutter/material.dart';

class InnerShadowBox extends StatelessWidget {
  const InnerShadowBox({
    Key? key,
    this.sizeScale = 1.1,
    this.offsetScale = .1,
    this.transitionStartFraction, //= 0.7,
    this.transitionStartOffset = 12,
    required this.child,
    required this.direction,
    required this.color,
    this.borderRadius,
  }) : super(key: key);

  final Widget child;

  final double sizeScale;
  final double offsetScale;

  /// Color of the shadow
  final Color color;

  /// Where to anchor the inner shadow
  final Alignment direction;

  /// 0.0: Start at Center
  /// 0.5: Start half way
  /// 1.0: Start at edge (nothing to see in that case)
  final double? transitionStartFraction;

  /// Width of the shadow from which [transitionStartFraction] is calculated.
  final double? transitionStartOffset;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: child,
      foregroundPainter: _BoxInnerShadowPainter(
        sizeScale: sizeScale,
        offsetScale: offsetScale,
        color: color,
        direction: direction,
        transitionStartFraction: transitionStartOffset == null ? transitionStartFraction : null,
        transitionStartOffset: transitionStartOffset,
        borderRadius: borderRadius ??
            const BorderRadius.all(
              Radius.circular(0),
            ),
      ),
    );
  }
}

class _BoxInnerShadowPainter extends CustomPainter {
  final double sizeScale;
  final double offsetScale;
  final Color color;
  final Alignment direction;
  final double? transitionStartFraction;
  final double? transitionStartOffset;

  final BorderRadius borderRadius;

  _BoxInnerShadowPainter({
    required this.sizeScale,
    required this.offsetScale,
    required this.color,
    required this.direction,
    required this.transitionStartFraction,
    required this.transitionStartOffset,
    required this.borderRadius,
  })  : assert(transitionStartOffset == null || transitionStartFraction == null),
        assert(transitionStartOffset != null || transitionStartFraction != null);

  @override
  void paint(Canvas canvas, Size size) {
    // Adjust Size ------------------------------------
    double width = size.width * sizeScale;
    double height = size.height * sizeScale;

    // Adjust Offset ------------------------------------
    double adjustPosX = direction.x * size.width * offsetScale;
    double adjustPosY = direction.y * size.height * offsetScale;

    // move only to left/top when those components are negative (e.g. top-left aligned)
    // for e.g. bottom-right, the width increase will already move it out to bottom-right
    Path rect = Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(
          /// move left aligned shadow to the left (alignment -1)
          /// this way, with increased width, its border is aligned with the right border of the child
          ///
          /// dont move left if the shadow is right aliged (+1)
          /// here it is already moved out via the with and stays aligned with the left border of the child
          0 + min(adjustPosX, 0),
          0 + min(adjustPosY, 0),
          width + min(adjustPosX, 0),
          height + min(adjustPosY, 0),
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
      );

    // circle starts from center, this starts from one side to the other
    final _transitionStartX = transitionStartFraction ?? 1 - (transitionStartOffset! / width * 2);
    final _transitionStartY = transitionStartFraction ?? 1 - (transitionStartOffset! / height * 2);

    print(_transitionStartX);
    print(_transitionStartY);

    final paintX = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-direction.x, 0),
        end: Alignment(direction.x, 0),
        stops: [_transitionStartX, 1],
        colors: [
          Colors.transparent,
          color,
        ],
      ).createShader(rect.getBounds());

    final paintY = Paint()
      ..shader = LinearGradient(
        begin: Alignment(0, -direction.y),
        end: Alignment(0, direction.y),
        stops: [_transitionStartY, 1],
        colors: [
          Colors.transparent,
          color,
        ],
      ).createShader(rect.getBounds());

    canvas.drawPath(rect, paintX);
    canvas.drawPath(rect, paintY);
  }

  @override
  bool shouldRepaint(_BoxInnerShadowPainter oldDelegate) {
    return false;
  }
}
