import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/values/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      required this.label,
      this.color = Colors.blue})
      : super(key: key);

  final Function onPressed;
  final String label;
  final Color? color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: RaisedButton.icon(
        onPressed: () => onPressed(),
        color: color,
        icon: Icon(icon, color: colorIconWhite,),
        label: Text(
          label.toUpperCase(),
          style: buttonWhite.copyWith(fontSize: 18.sp),
        ),
      ),
    );
  }
}
