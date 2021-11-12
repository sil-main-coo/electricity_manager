import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/feature_buttons_widget.dart';
import 'widgets/header_widget.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FeatureHeader(),
          Divider(),
          SizedBox(
            height: 24.w,
          ),
          FeatureButtonsWidget()
        ],
      ),
    );
  }
}
