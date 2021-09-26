import 'package:electricity_manager/commons/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'app_button.dart';

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget(
      {Key? key, required this.onPressed, required this.label})
      : super(key: key);

  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppButton(
        onPressed: () => onPressed(),
        label: label,
      ),
    );
  }
}
