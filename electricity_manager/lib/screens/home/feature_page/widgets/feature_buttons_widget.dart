import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/screens/components/grid_item_button.dart';
import 'package:electricity_manager/screens/create_reports/resolve_problem/list_resolve_report_screen.dart';
import 'package:electricity_manager/screens/create_reports/take_back_electricity/list_take_back_report_screen.dart';
import 'package:electricity_manager/screens/manager_account/manager_account_screen.dart';
import 'package:electricity_manager/screens/manager_device/manager_device_screen.dart';
import 'package:electricity_manager/utils/commons/icon_constants.dart';
import 'package:flutter/material.dart';

class FeatureButtonsWidget extends StatelessWidget {
  final _appBloc = getIt.get<AppBloc>();

  @override
  Widget build(BuildContext context) {
    final widgets = _appBloc.isAdmin
        ? [
            GridItemButton(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ManagerAccountScreen())),
              iconPath: IconConstants.icStaffs,
              label: "Quản lý tài khoản",
            ),
            GridItemButton(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ManagerDeviceScreen())),
              iconPath: IconConstants.icDevice,
              label: "Quản lý vật tư",
            )
          ]
        : [
            GridItemButton(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ListTakeBackReportScreen())),
              iconPath: IconConstants.icReturn,
              label: "Thu hồi công tơ",
            ),
            GridItemButton(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ListResolveReportScreen())),
              iconPath: IconConstants.icResolve,
              label: "Xử lý sự cố",
            ),
            GridItemButton(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => ManagerAccountScreen())),
              iconPath: IconConstants.icStaffs,
              label: "Nhân viên",
            ),
          ];

    return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      shrinkWrap: true,
      mainAxisSpacing: 8.0,
      children: widgets,
    );
  }
}
