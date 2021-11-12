import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/utils/commons/icon_constants.dart';
import 'package:electricity_manager/utils/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class FeatureHeader extends StatelessWidget {
  final appBloc = getIt.get<AppBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 150.h,
      child: Row(
        children: [
          Expanded(flex: 2, child: _introductionWidget(context)),
          Expanded(child: _imageWelcome()),
        ],
      ),
    );
  }

  Widget _introductionWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 200.w,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Chào ${appBloc.user?.profile?.fullName},',
              style: Theme.of(context).textTheme.title?.copyWith(
                  fontSize: 22.sp, fontWeight: FontWeight.bold, color: primary),
            ),
          ),
        ),
        SizedBox(
          width: 16.w,
        ),
        Text(
          'Chúc bạn một ngày làm việc hiệu quả!',
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          'Hãy bắt đầu bằng cách chọn các\ntính năng ở phía dưới.',
        ),
      ],
    );
  }

  Widget _imageWelcome() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SvgPicture.asset(IconConstants.welcome),
    );
  }
}
