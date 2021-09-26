import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppField extends StatefulWidget {
  const AppField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.fcNode,
      this.autoFocus = false,
      this.textInputAction,
      this.keyboardType,
      required this.label,
      this.preIcon})
      : super(key: key);

  final TextEditingController controller;
  final FocusNode? fcNode;
  final bool autoFocus;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String label, hintText;
  final Widget? preIcon;

  @override
  _AppFieldState createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
    if (widget.fcNode != null) widget.fcNode?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 16.sp);
    final hintStyle = style.copyWith(color: Colors.grey);
    final labelStyle = TextStyle(fontSize: 14.sp);
    final errorStyle = TextStyle(fontSize: 11.sp, color: Colors.red);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.fcNode,
      autofocus: widget.autoFocus,
      style: style,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Trường bắt buộc';
        return null;
      },
      decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          hintText: widget.hintText,
          errorStyle: errorStyle,
          prefixIcon: widget.preIcon),
    );
  }
}
