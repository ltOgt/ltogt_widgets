import 'package:flutter/material.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

class BrickTextField extends StatefulWidget {
  const BrickTextField({
    Key? key,
    required this.onChange,
    required this.hint,
    this.maxLines,
    this.bgColor,
    this.textColor,
    this.fontSize,
    this.editable = true,
    this.showLine = true,
  }) : super(key: key);

  final Function(String text) onChange;
  final String hint;
  final int? maxLines;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final bool editable;
  final bool showLine;

  @override
  State<BrickTextField> createState() => _BrickTextFieldState();
}

class _BrickTextFieldState extends State<BrickTextField> {
  void onChange() => widget.onChange(controller.text);
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onChange);
  }

  @override
  void dispose() {
    controller.removeListener(onChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrickTextInput(
      controller: controller,
      hint: widget.hint,
      bgColor: widget.bgColor,
      editable: widget.editable,
      fontSize: widget.fontSize,
      maxLines: widget.maxLines,
      textColor: widget.textColor,
      showLine: widget.showLine,
    );
  }
}
