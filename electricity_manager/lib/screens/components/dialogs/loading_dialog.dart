import 'package:electricity_manager/utils/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialog {
  static void show(BuildContext context, [String? mess]) {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
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
                  ),
                ],
              ),
            ));
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(LoadingDialog);
  }
}
