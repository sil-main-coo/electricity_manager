import 'package:electricity_manager/screens/components/custom_cupertino_date_picker.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:electricity_manager/utils/extensions/date_time_extension.dart';

class NavigatorBarWidget extends StatefulWidget {
  const NavigatorBarWidget(
      {Key? key, required this.dateTime, required this.onChanged})
      : super(key: key);
  final DateTime dateTime;
  final Function(DateTime) onChanged;

  @override
  _NavigatorBarWidgetState createState() => _NavigatorBarWidgetState();
}

class _NavigatorBarWidgetState extends State<NavigatorBarWidget> {
  late DateTime _date;

  void _showDateTimePicker(BuildContext context, DateTime dateTime) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => CupertinoDatePickerWithTitle(
              initialDateTime: dateTime,
              maximumDate: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              onPressedDone: (value) {
                setState(() {
                  _date = value;
                  widget.onChanged(value);
                });
              },
            ));
  }

  @override
  void initState() {
    super.initState();
    _date = widget.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      padding: EdgeInsets.all(8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _date = _date.subMonth(1);
                widget.onChanged(_date);
              });
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _showDateTimePicker(context, widget.dateTime),
            child: Text(
              Utils.dateToMonthAndYearString(_date),
              style: titleWhite.copyWith(fontSize: 22.sp),
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _date = _date.addMonth(1);
                widget.onChanged(_date);
              });
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
