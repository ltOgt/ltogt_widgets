import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:ltogt_widgets/ltogt_widgets.dart';

class BrickIconButton extends StatelessWidget {
  const BrickIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.size = 40.0,
  }) : super(key: key);

  final void Function(Rect? rect) onPressed;
  final Widget icon;

  final double size;
  double get iconSize => size - 10;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        child: BrickInkWell(
          color: Colors.black,
          hoverColor: Colors.white24,
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
