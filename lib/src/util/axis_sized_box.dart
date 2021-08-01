import 'package:flutter/widgets.dart';

class AxisSizedBox extends StatelessWidget {
  const AxisSizedBox({
    Key? key,
    required this.mainAxis,
    this.mainAxisSize,
    this.crossAxisSize,
    this.child,
  }) : super(key: key);

  final Axis mainAxis;
  final double? mainAxisSize;
  final double? crossAxisSize;
  final Widget? child;

  bool get _isHorizontal => mainAxis == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _isHorizontal ? crossAxisSize : mainAxisSize,
      width: _isHorizontal ? mainAxisSize : crossAxisSize,
      child: child,
    );
  }
}
