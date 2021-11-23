import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/data/remote/auth_remote_provider.dart';
import 'package:electricity_manager/data/remote/device_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/device.dart';
import 'package:electricity_manager/models/resolve_report_model.dart';
import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/screens/create_reports/resolve_problem/pages/basic_info_page.dart';
import 'package:electricity_manager/screens/create_reports/resolve_problem/pages/resolve_info_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'confirm_resolve_report_screen.dart';
import 'pages/conclude_page.dart';
import 'pages/device_info_page.dart';

class CreateResolveReportScreen extends StatefulWidget {
  const CreateResolveReportScreen({Key? key}) : super(key: key);

  @override
  _CreateResolveReportScreenState createState() =>
      _CreateResolveReportScreenState();
}

class _CreateResolveReportScreenState extends State<CreateResolveReportScreen> {
  final _appBloc = getIt.get<AppBloc>();

  int _index = 0;
  ResolveReportModel _resolveReportModel = ResolveReportModel();

  void _nextStep() {
    setState(() {
      _index++;
    });
  }

  void _backStep() {
    setState(() {
      _index--;
    });
  }

  void _finishStep() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ConfirmResolveScreen(
                  reportModel: _resolveReportModel,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Device>>(
        future: getIt.get<DeviceRemoteProvider>().fetchDevices(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return IndexedStack(
              index: _index,
              children: [
                ResoleBasicInfoPage(
                  nextCallback: (resolveName, resolveAddress, electricityUnits,
                      regionUnits, relatedUnits) {
                    _resolveReportModel.setBasicInfo(
                        resolveName: resolveName,
                        resolveAddress: resolveAddress,
                        electricityUnits: electricityUnits,
                        regionUnits: regionUnits,
                        relatedUnits: relatedUnits);
                    _nextStep();
                  },
                ),
                ResolveInfoPage(
                  backCallback: _backStep,
                  nextCallback: (happening, scene, resolveReason) {
                    _resolveReportModel.setResolveInfo(
                        happening: happening,
                        scene: scene,
                        resolveReason: resolveReason);
                    _nextStep();
                  },
                ),
                ResolveDevicePage(
                  devices: snapshot.data!,
                  backCallback: _backStep,
                  nextCallback: (devices) {
                    _resolveReportModel.setDevices(devices: devices);
                    _nextStep();
                  },
                ),
                ResolveConcludePage(
                  backCallback: _backStep,
                  nextCallback: (beforeImages, finishedImages, signImage,
                      resolveMeasure, conclude) {
                    _resolveReportModel.setConcludeInfo(
                        beforeImages: beforeImages,
                        finishedImages: finishedImages,
                        signImage: signImage,
                        resolveMeasure: resolveMeasure,
                        conclude: conclude);
                    _finishStep();
                  },
                )
              ],
            );
          }
          return Center(
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
