import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'app_button.dart';

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.color = Colors.blue})
      : super(key: key);

  final Function onPressed;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppButton(
        onPressed: () => onPressed(),
        label: label,
        color: color,
      ),
    );
  }
}
