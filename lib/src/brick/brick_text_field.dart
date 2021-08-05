import 'package:flutter/material.dart';
import 'package:ltogt_widgets/ltogt_widgets.dart';

class BrickTextField extends StatefulWidget {
  const BrickTextField({
    Key? key,
    required this.hint,
    required this.onChange,
    this.onGainFocus,
    this.maxLines,
    this.bgColor, // TODO replace with theme
    this.textColor,
    this.fontSize,
    this.editable = true,
    this.showLine = true,
    this.autofocus = false,
  }) : super(key: key);

  final Function(String text) onChange;
  final Function(String text)? onGainFocus;
  final String hint;
  final int? maxLines;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final bool editable;
  final bool showLine;
  final bool autofocus;

  @override
  State<BrickTextField> createState() => _BrickTextFieldState();
}

class _BrickTextFieldState extends State<BrickTextField> {
  String previousValue = "";

  void onChange() {
    // might be triggered simply on focus change
    // only trigger callback when value actually changed

    String? _value = controller.text;
    if (_value != previousValue) {
      widget.onChange(_value);
      setState(() {
        previousValue = _value;
      });
    } else {
      widget.onGainFocus?.call(previousValue);
    }
  }

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
      autofocus: widget.autofocus,
    );
  }
}
