import 'package:flutter/material.dart';
import 'package:ltogt_widgets/src/const/border_radius.dart';
import 'package:ltogt_widgets/src/const/padding.dart';

class BrickTextInput extends StatelessWidget {
  const BrickTextInput({
    Key? key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.bgColor,
    this.textColor,
    this.fontSize,
    this.editable = true,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final int? maxLines;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BORDER_RADIUS_ALL_10,
      child: Container(
        padding: PADDING_HORIZONTAL_5,
        color: bgColor,
        child: TextField(
          enabled: editable,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
          decoration: InputDecoration(
            hintText: hint,
          ),
          maxLines: maxLines,
          controller: controller,
        ),
      ),
    );
  }
}
