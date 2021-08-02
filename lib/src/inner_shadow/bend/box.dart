import 'dart:math';

import 'package:flutter/material.dart';

class InnerShadowBox extends StatelessWidget {
  const InnerShadowBox({
    Key? key,
    this.sizeDelta = 10,
    this.transitionStartOffset = 12,
    required this.child,
    required this.direction,
    required this.color,
    this.borderRadius,
  }) : super(key: key);

  final Widget child;

  /// How much larger the shadow shape should be
  final double sizeDelta;

  /// Color of the shadow
  final Color color;

  /// Where to anchor the inner shadow
  final Alignment direction;

  /// Width of the shadow from which [transitionStartFraction] is calculated.
  final double transitionStartOffset;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: child,
      foregroundPainter: _BoxInnerShadowPainter(
        sizeDelta: sizeDelta,
        color: color,
        direction: direction,
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
  final double sizeDelta;
  final Color color;
  final Alignment direction;
  final double transitionStartOffset;

  final BorderRadius borderRadius;

  _BoxInnerShadowPainter({
    required this.sizeDelta,
    required this.color,
    required this.direction,
    required this.transitionStartOffset,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Adjust Offset ------------------------------------
    double adjustPosXForSize = direction.x * (sizeDelta);
    double adjustPosYForSize = direction.y * (sizeDelta);

    // Adjust Size ------------------------------------
    double width = size.width + sizeDelta;
    double height = size.height + sizeDelta;

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
          0 + min(adjustPosXForSize, 0),
          0 + min(adjustPosYForSize, 0),
          width + min(adjustPosXForSize, 0),
          height + min(adjustPosYForSize, 0),
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
      );

    /// Calculate the fractional stops from fixed width
    final _transitionStartX = 1 - (transitionStartOffset / width * 2);
    final _transitionStartY = 1 - (transitionStartOffset / height * 2);

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
