import 'package:electricity_manager/commons/space_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LayoutHaveFloatingButton extends StatelessWidget {
  const LayoutHaveFloatingButton({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          child,
          SizedBox(
            height: marginBottomHaveFloating.h,
          )
        ],
      ),
    );
  }
}
