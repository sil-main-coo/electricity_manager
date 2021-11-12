import 'package:electricity_manager/utils/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoadingWidget extends StatelessWidget {
  final String? mess;

  const AppLoadingWidget({this.mess});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: Container(
              color: primary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        width: 50.w,
                        height: 50.w,
                        child: CircularProgressIndicator()),
                    Visibility(
                      visible: mess != null,
                      child: Text(
                        mess.toString(),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .caption!
                            .copyWith(fontSize: ScreenUtil().setSp(fzCaption)),
                      ),
                    )
                  ],
                ),
              )),
        ));
  }
}
