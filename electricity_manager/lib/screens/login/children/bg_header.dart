
import 'package:electricity_manager/utils/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget bgHeaderLogin() {
  return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
        color: primary,
      ),
      height: ScreenUtil().setHeight(400),
      width: double.infinity
  );
}
