import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridItemButton extends StatelessWidget {
  final IconData? iconData;
  final String label;
  final bool isUnderDevelopment;
  final Function onTap;
  final String iconPath;

  GridItemButton(
      {this.iconData,
      required this.label,
      required this.iconPath,
      required this.onTap,
      this.isUnderDevelopment = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconData != null
                  ? Icon(iconData)
                  : SvgPicture.asset(
                      iconPath,
                      height: 48.w,
                      width: 48.w,
                    ),
              SizedBox(
                height: 8.w,
              ),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(fontSize: 14.w),
              )
            ],
          ),
        ),
      ),
    );
  }
}
