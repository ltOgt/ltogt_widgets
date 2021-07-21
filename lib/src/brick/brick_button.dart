import 'package:flutter/material.dart';
import 'package:ltogt_utils_flutter/ltogt_utils_flutter.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

class BrickButton extends StatefulWidget {
  const BrickButton({
    Key? key,
    required this.text,
    required this.onPress,
    this.buildMenu,
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

  /// Whether to build a floating menu on button click.
  /// The builder is passed the global rect of this button (size and offset on screen).
  /// This rect can be used to position the menu relative to the button.
  final Positioned Function(BuildContext context, Rect globalButtonRect)? buildMenu;

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

  GlobalKey globalKey = GlobalKey();

  void onTap() {
    widget.onPress?.call();
    if (widget.buildMenu != null) {
      Rect buttonRect = RenderHelper.getRect(globalKey: globalKey)!;
      showDialog(
        context: context,
        builder: (context) => Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: const Color(0x22000000),
              ),
            ),
            widget.buildMenu!.call(context, buttonRect),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      key: globalKey,
      borderRadius: widget.borderRadius,
      child: Material(
        color: widget.onPress == null ? widget.bgColorDisabled : bgColor,
        child: InkWell(
          onHover: setColorOnChangeHover,
          onTap: widget.onPress == null ? null : onTap,
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
