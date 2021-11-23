import 'package:electricity_manager/models/device.dart';
import 'package:flutter/material.dart';

class DeviceWidgetModel {
  final deviceCtrl = TextEditingController();
  final actionCtrl = TextEditingController(text: 'Lắp mới');
  final stateCtrl = TextEditingController();
  Device? device;
  int count = 1;

  DeviceWidgetModel({this.device, this.count = 1});

  dispose() {
    this.deviceCtrl.dispose();
  }
}
