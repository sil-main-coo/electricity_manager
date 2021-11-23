import 'package:electricity_manager/screens/components/dialogs/selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropDownField<T> extends StatefulWidget {
  const DropDownField(
      {Key? key,
      this.showBorder = true,
      required this.selected,
      required this.initial,
      required this.data,
      required this.controller,
      required this.titleSelection,
      this.isRequired = true})
      : super(key: key);

  final TextEditingController controller;
  final String titleSelection;
  final bool isRequired;
  final List<T> data;
  final T? initial;
  final Function(T) selected;
  final bool showBorder;

  @override
  _DropDownFieldState<T> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<DropDownField<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => SelectionDialog.show<T>(
          context: context,
          title: widget.titleSelection,
          data: widget.data,
          dataSelected: widget.initial,
          callback: (item) {
            widget.controller.text = item.toString();
            widget.selected(item);
          }),
      child: TextFormField(
        controller: widget.controller,
        enabled: false,
        validator: widget.isRequired
            ? (value) {
                if (value == null || value.isEmpty) return 'Trường bắt buộc';
                return null;
              }
            : null,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: Colors.blue,
          ),
          errorStyle: TextStyle(fontSize: 11.sp, color: Colors.red),
          border: widget.showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  borderSide: BorderSide(width: 1.0),
                )
              : InputBorder.none,
        ),
      ),
    );
  }
}
