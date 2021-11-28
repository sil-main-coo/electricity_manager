import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/data/remote/auth_remote_provider.dart';
import 'package:electricity_manager/data/remote/device_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/device.dart';
import 'package:electricity_manager/models/take_back_report_model.dart';
import 'package:electricity_manager/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'confirm_take_back_screen.dart';
import 'pages/additional_page.dart';
import 'pages/basic_info_page.dart';
import 'pages/device_info_page.dart';
import 'pages/electricity_info.dart';

class TakeBackElectricityScreen extends StatefulWidget {
  const TakeBackElectricityScreen({Key? key}) : super(key: key);

  @override
  _TakeBackElectricityScreenState createState() =>
      _TakeBackElectricityScreenState();
}

class _TakeBackElectricityScreenState extends State<TakeBackElectricityScreen> {
  final _appBloc = getIt.get<AppBloc>();

  int _index = 0;
  TakeBackReportModel _takeBackReportModel = TakeBackReportModel();

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
            builder: (_) => ConfirmTakeBackScreen(
                  reportModel: _takeBackReportModel,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Device>>(
        future: getIt.get<DeviceRemoteProvider>().fetchDevices(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return _buildStaffStream(snapshot.data!);
          }
          return Center(
            child: const CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildStaffStream(List<Device> devices) {
    return StreamBuilder<Event>(
        stream: getIt.get<AuthRemoteProvider>().streamData(),
        builder: (context, snapshot) {
          List<UserProfile> staffs = [];

          if (snapshot.hasData) {
            final Map profilesData = snapshot.data?.snapshot.value;

            profilesData.forEach((key, value) {
              final user = Map<String, dynamic>.from(value);
              final profile = UserProfile.fromJson(
                  Map<String, dynamic>.from(user['profile']));

              if (!profile.isAdmin &&
                  profile.id != _appBloc.user?.profile?.id) {
                staffs.add(profile);
              }
            });
            return IndexedStack(
              index: _index,
              children: [
                BasicInfoPage(
                  staffs: staffs,
                  nextCallback:
                      (clientCode, clientName, clientAddress, staffs) {
                    _takeBackReportModel.setBasicInfo(
                        clientCode: clientCode,
                        clientName: clientName,
                        clientAddress: clientAddress,
                        staffs: staffs);
                    _nextStep();
                  },
                ),
                ElectricityInfoPage(
                  nextCallback: (electricNumber, beforeImages, finishedImages) {
                    _takeBackReportModel.setElectricityInfo(
                        electricNumber: electricNumber,
                        beforeImages: beforeImages,
                        finishedImages: finishedImages);
                    _nextStep();
                  },
                  backCallback: _backStep,
                ),
                DeviceInfoPage(
                  devices: devices,
                  nextCallback: (devices) {
                    _takeBackReportModel.setDevices(devices: devices);
                    _nextStep();
                  },
                  backCallback: _backStep,
                ),
                AdditionalPage(
                  nextCallback:
                      (staffSignImage, managerSignImage, presidentSignImage) {
                    _takeBackReportModel.setAdditional(
                        staffSignImage: staffSignImage,
                        managerSignImage: managerSignImage,
                        presidentSignImage: presidentSignImage);
                    _finishStep();
                  },
                  backCallback: _backStep,
                )
              ],
            );
          }

          return Center(
            child: const CircularProgressIndicator(),
          );
        });
  }
}
