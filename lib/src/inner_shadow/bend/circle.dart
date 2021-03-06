import 'package:flutter/material.dart';
import 'package:ltogt_utils/ltogt_utils.dart';

class InnerShadowCircle extends StatelessWidget {
  const InnerShadowCircle({
    Key? key,
    this.adjust = 7,
    this.transitionStartFraction, // = 0.7,
    this.transitionStartOffset = 12,
    required this.child,
    required this.direction,
    required this.color,
  })  : assert(transitionStartFraction == null || transitionStartOffset == null),
        assert(transitionStartFraction != null || transitionStartOffset != null),
        super(key: key);

  final Widget child;

  /// Parameter to tweak radius + offset of shadow circle
  final double adjust;

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

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: child,
      foregroundPainter: _CircleInnerShadowPainter(
        adjust: adjust,
        color: color,
        direction: direction,
        transitionStartFraction: transitionStartFraction,
        transitionStartOffset: transitionStartOffset,
      ),
    );
  }
}

class _CircleInnerShadowPainter extends CustomPainter {
  final double adjust;
  final Color color;
  final Alignment direction;
  final double? transitionStartFraction;
  final double? transitionStartOffset;

  _CircleInnerShadowPainter({
    required this.adjust,
    required this.color,
    required this.direction,
    required this.transitionStartFraction,
    required this.transitionStartOffset,
  })  : assert(transitionStartFraction == null || transitionStartOffset == null),
        assert(transitionStartFraction != null || transitionStartOffset != null);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2 + adjust;

    /// Calculate offset scalar for shadow based on alignment
    // TL (-.5a,-.5a)   (-1,-1)
    // TR (-1.5a,-.5a)  ( 1,-1)
    // BR (-1.5a,-1.5a) ( 1, 1)
    // BL (-.5a,-1.5a)  (-1, 1)
    double rescale(double v) => NumHelper.rescale(value: -1 * v, max: 1, min: -1, newMax: -.5, newMin: -1.5);
    final adjustX = rescale(direction.x) * adjust;
    final adjustY = rescale(direction.y) * adjust;

    canvas.translate(radius, radius);
    Offset center = Offset(adjustX, adjustY);

    Path oval = Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );

    final _transitionStartFraction = transitionStartFraction ?? 1 - (transitionStartOffset! / radius);

    final paint = Paint()
      ..shader = RadialGradient(
        stops: [_transitionStartFraction, 1],
        colors: [
          Colors.transparent,
          color,
        ],
      ).createShader(Rect.fromCircle(
        center: center,
        radius: radius,
      ));

    canvas.drawPath(oval, paint);
  }

  @override
  bool shouldRepaint(_CircleInnerShadowPainter oldDelegate) {
    return false;
  }
}
