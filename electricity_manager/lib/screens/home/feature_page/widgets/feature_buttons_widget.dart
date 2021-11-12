import 'package:electricity_manager/screens/components/grid_item_button.dart';
import 'package:electricity_manager/utils/commons/icon_constants.dart';
import 'package:flutter/material.dart';

class FeatureButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      shrinkWrap: true,
      mainAxisSpacing: 8.0,
      children: <Widget>[
        GridItemButton(
          onTap: () => _onTapDrumSchedule(context),
          iconPath: IconConstants.icHealth,
          label: "Thay công tơ",
        ),
        GridItemButton(
          onTap: () => _onTapDrumSchedule(context),
          iconPath: IconConstants.icHealth,
          label: "Xử lý sự cố",
        ),
        GridItemButton(
          onTap: () => _onTapDrumSchedule(context),
          iconPath: IconConstants.icHealth,
          label: "Thu hồi công tơ",
        ),
      ],
    );
  }

  void _onTapDrumSchedule(BuildContext context) {

  }
}
