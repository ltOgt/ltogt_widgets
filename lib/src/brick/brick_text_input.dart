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
    this.showLine = true,
    this.contentPadding = const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final int? maxLines;
  final Color? bgColor;
  final Color? textColor;
  final double? fontSize;
  final bool editable;
  final bool showLine;
  final EdgeInsets contentPadding;

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
            border: showLine ? null : InputBorder.none,
            focusedBorder: showLine ? null : InputBorder.none,
            enabledBorder: showLine ? null : InputBorder.none,
            errorBorder: showLine ? null : InputBorder.none,
            disabledBorder: showLine ? null : InputBorder.none,
            contentPadding: contentPadding,
          ),
          maxLines: maxLines,
          controller: controller,
        ),
      ),
    );
  }
}
