import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';

class BrickInkWell extends StatelessWidget {
  BrickInkWell({
    Key? key,
    required this.onTap,
    required this.child,
    this.color,
    this.hoverColor,
  }) : super(key: key);

  final Function(Rect? globalRect)? onTap;
  final Widget child;
  final Color? color;
  final Color? hoverColor;

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        key: globalKey,
        hoverColor: hoverColor,
        onTap: null == onTap
            ? null
            : () => onTap!.call(
                  RenderHelper.getRect(globalKey: globalKey),
                ),
        child: child,
      ),
    );
  }
}
