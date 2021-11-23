import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppField extends StatefulWidget {
  const AppField(
      {Key? key,
      this.isMultiLine = false,
      this.isRequired = true,
      this.autoDispose = false,
      this.obscureText = false,
      this.validator,
      this.enable = true,
      this.isName = false,
      this.nextFcNode,
      required this.controller,
      required this.hintText,
      this.fcNode,
      this.autoFocus = false,
      this.textInputAction,
      this.keyboardType,
      this.label,
      this.preIcon})
      : super(key: key);

  final TextEditingController controller;
  final FocusNode? fcNode, nextFcNode;
  final bool autoFocus;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? label, hintText;
  final Widget? preIcon;
  final bool isName;
  final bool enable;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool autoDispose;
  final bool isRequired;
  final bool isMultiLine;

  @override
  _AppFieldState createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  @override
  void dispose() {
    super.dispose();
    if (widget.autoDispose) {
      widget.controller.dispose();
      if (widget.fcNode != null) widget.fcNode?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 16.sp);
    final hintStyle = style.copyWith(color: Colors.grey);
    final labelStyle = TextStyle(fontSize: 14.sp);
    final errorStyle = TextStyle(fontSize: 11.sp, color: Colors.red);

    return Padding(
      padding: widget.isMultiLine
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(vertical: 8.0.w),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.fcNode,
        autofocus: widget.autoFocus,
        enabled: widget.enable,
        maxLines: widget.isMultiLine ? 10: 1,
        obscureText: widget.obscureText,
        textCapitalization:
            widget.isName ? TextCapitalization.words : TextCapitalization.none,
        onFieldSubmitted: (value) {
          if (widget.textInputAction == TextInputAction.next) {
            if (widget.nextFcNode != null) {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(widget.nextFcNode);
            }
            return;
          }

          if (widget.textInputAction == TextInputAction.done) {
            FocusScope.of(context).unfocus();
          }
        },
        style: style,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        validator: !widget.isRequired
            ? null
            : widget.validator != null
                ? widget.validator
                : (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Trường bắt buộc';
                    return null;
                  },
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          contentPadding: EdgeInsets.all(8.0.w),
          hintText: widget.hintText,
          errorStyle: errorStyle,
          prefixIcon: widget.preIcon,
          border: widget.enable
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(width: 1.0),
                )
              : null,
        ),
      ),
    );
  }
}
