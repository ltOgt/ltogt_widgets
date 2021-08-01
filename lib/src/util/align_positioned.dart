import 'package:flutter/widgets.dart';

// could probably easily be done with Aligned
// for now helper for full cross axis sized positioned
class AlignPositioned extends StatelessWidget {
  const AlignPositioned({
    Key? key,
    required this.alignment,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Alignment alignment;
  void assertAlignment() {
    assert(
      [
        Alignment.centerLeft,
        Alignment.centerRight,
        Alignment.topCenter,
        Alignment.bottomCenter,
      ].contains(alignment),
      "Unsupported alignment: $alignment",
    );
  }

  @override
  Widget build(BuildContext context) {
    assertAlignment();

    double? top, left, bottom, right;
    if (alignment == Alignment.topCenter) {
      top = 0;
      right = 0;
      left = 0;
    }
    //
    else if (alignment == Alignment.centerLeft) {
      bottom = 0;
      top = 0;
      left = 0;
    }
    //
    else if (alignment == Alignment.centerRight) {
      bottom = 0;
      top = 0;
      right = 0;
    }
    //
    else if (alignment == Alignment.bottomCenter) {
      bottom = 0;
      right = 0;
      left = 0;
    }

    return Positioned(
      top: top,
      right: right,
      left: left,
      bottom: bottom,
      child: child,
    );
  }
}
