import 'package:flutter/material.dart';
import 'package:ltogt_widgets/src/colors.dart';

class BrickButton extends StatefulWidget {
  const BrickButton({
    Key? key,
    required this.text,
    required this.onPress,
    this.bgColor = BrickColors.BLACK,
    this.fgColor = BrickColors.WHITE,
    this.bgColorSelected = BrickColors.GREY_4,
    this.fgColorSelected = BrickColors.WHITE,
    this.bgColorDisabled = BrickColors.GREY_2,
    this.fgColorDisabled = BrickColors.WHITE,
    this.fontSize = 20,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  }) : super(key: key);

  final String text;
  final Function()? onPress;

  final Color bgColor;
  final Color fgColor;
  final Color bgColorSelected;
  final Color fgColorSelected;
  final Color bgColorDisabled;
  final Color fgColorDisabled;
  final double fontSize;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  @override
  State<BrickButton> createState() => _BrickButtonState();
}

class _BrickButtonState extends State<BrickButton> {
  @override
  void initState() {
    super.initState();

    bgColor = widget.bgColor;
    fgColor = widget.fgColor;
  }

  late Color bgColor;
  late Color fgColor;

  void setColorOnChangeHover(bool isHovering) {
    setState(() {
      bgColor = isHovering ? widget.bgColorSelected : widget.bgColor;
      fgColor = isHovering ? widget.fgColorSelected : widget.fgColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Material(
        color: widget.onPress == null ? widget.bgColorDisabled : bgColor,
        child: InkWell(
          onHover: setColorOnChangeHover,
          onTap: widget.onPress,
          child: Padding(
            padding: widget.padding,
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.onPress == null ? widget.fgColorDisabled : fgColor,
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
