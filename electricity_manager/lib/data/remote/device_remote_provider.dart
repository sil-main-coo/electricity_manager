import 'package:electricity_manager/models/device.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

/// Singleton
class DeviceRemoteProvider {
  final refUsersDB = FirebaseDatabase.instance.reference().child('devices');

  List<Device> _devices = [];

  Future<List<Device>> fetchDevices() async {
    if (_devices.isNotEmpty) return _devices;

    try {
      final snapshot = await refUsersDB.once();

      if (snapshot.exists && snapshot.value != null) {
        final Map<String, dynamic> snapshotValue =
            Map<String, dynamic>.from(snapshot.value);
        snapshotValue.forEach((k, value) {
          final Map<String, dynamic> deviceJson =
              Map<String, dynamic>.from(value);
          _devices.add(Device.fromJson(deviceJson));
        });
      }

      return _devices;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Đã xảy ra lỗi. Vui lòng thử lại!');
    }
  }
}
