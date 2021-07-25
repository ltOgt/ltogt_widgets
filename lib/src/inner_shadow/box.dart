import 'package:flutter/material.dart';

class InnerShadowBox extends StatelessWidget {
  const InnerShadowBox({
    Key? key,
    this.sizeScale = 1.1,
    this.offsetScale = .1,
    this.transitionStart = 0.75,
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
  final double transitionStart;

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
        transitionStart: transitionStart,
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
  final double transitionStart;
  final BorderRadius borderRadius;

  _BoxInnerShadowPainter({
    required this.sizeScale,
    required this.offsetScale,
    required this.color,
    required this.direction,
    required this.transitionStart,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Adjust Size ------------------------------------
    double width = size.width * sizeScale;
    double height = size.height * sizeScale;

    // Adjust Offset ------------------------------------
    double adjustPosX = direction.x * size.width * offsetScale;
    double adjustPosY = direction.x * size.height * offsetScale;

    Path rect = Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(
          0 + adjustPosX,
          0 + adjustPosY,
          width + adjustPosX,
          height + adjustPosY,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
      );

    final paintX = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-direction.x, 0),
        end: Alignment(direction.x, 0),
        stops: [transitionStart, 1],
        colors: [
          Colors.transparent,
          color,
        ],
      ).createShader(rect.getBounds());
    final paintY = Paint()
      ..shader = LinearGradient(
        begin: Alignment(0, -direction.y),
        end: Alignment(0, direction.y),
        stops: [transitionStart, 1],
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
