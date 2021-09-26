import 'package:electricity_manager/commons/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({Key? key, required this.onPressed, required this.label})
      : super(key: key);

  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: RaisedButton(
        onPressed: () => onPressed(),
        color: Colors.blue,
        child: Text(
          label.toUpperCase(),
          style: buttonWhite.copyWith(fontSize: 18.sp),
        ),
      ),
    );
  }
}
