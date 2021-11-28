import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CupertinoDatePickerWithTitle extends StatelessWidget {
  final DateTime initialDateTime;
  final DateTime? maximumDate;
  final DateTime? minimumDate;
  final CupertinoDatePickerMode? mode;
  final Function(DateTime) onPressedDone;
  final Function(DateTime)? onDateTimeChanged;

  CupertinoDatePickerWithTitle(
      {required this.initialDateTime,
      required this.onPressedDone,
      this.onDateTimeChanged,
      this.maximumDate,
      this.minimumDate,
      this.mode});

  late DateTime _dateTimeSelected;

  @override
  Widget build(BuildContext context) {
    _dateTimeSelected = initialDateTime;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Colors.white,
          height: 48.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    onPressedDone(_dateTimeSelected);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Xong',
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          child: CupertinoDatePicker(
            backgroundColor: Colors.white,
            initialDateTime: initialDateTime,
            onDateTimeChanged: (value) {
              _dateTimeSelected = value;
              if (onDateTimeChanged != null) {
                onDateTimeChanged!(value);
              }
            },
            maximumDate: maximumDate,
            minimumDate: minimumDate,
            mode: mode ?? CupertinoDatePickerMode.date,
          ),
        ),
      ],
    );
  }
}
