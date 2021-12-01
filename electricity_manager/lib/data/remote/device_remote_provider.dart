import 'package:electricity_manager/models/device.dart';
import 'package:electricity_manager/utils/error/remote_exception.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

/// Singleton
class DeviceRemoteProvider {
  final refUsersDB = FirebaseDatabase.instance.reference().child('devices');

  List<Device> _devices = [];

  Stream<Event> streamData() {
    return refUsersDB.onValue;
  }

  Future<List<Device>> fetchDevices() async {
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

  Future<void> removeDevice(String id) async {
    print(id);
    try {
      return await refUsersDB.child(id).remove();
    } catch (e) {
      print(e);
    }
    throw RemoteException('Xóa user thất bại');
  }

  Future<Device?> addNewDeviceToDB(Device model) async {
    try {
      final uid = refUsersDB.push();
      model.id = uid.key;
      await uid.set(model.toJson());
      return model;
    } on RemoteException catch (e) {
      throw e.toString();
    } catch (e) {
      throw RemoteException('Thêm user thất bại');
    }
  }
}
