import 'dart:io';
import 'dart:typed_data';

import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/utils/error/remote_exception.dart';
import 'package:electricity_manager/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRemoteProvider {
  final refUsersDB = FirebaseDatabase.instance.reference().child('users');
  final _refImageStorage =
      FirebaseStorage.instance.ref().child('hinh-anh').child('nhan-vien');
  var httpClient = new HttpClient();

  Stream<Event> streamData() {
    return refUsersDB.onValue;
  }

  Future<User?> signIn(User account) async {
    User? user;

    try {
      final authUserName = await getUserByUserName(account.useName!);

      if (authUserName.exists && authUserName.value != null) {
        final mapUser = Map<String, dynamic>.from(authUserName.value);

        mapUser.forEach((uid, data) {
          final Map<String, dynamic> uData = Map<String, dynamic>.from(data);

          if (uData['password'] == account.password) {
            // match pwd
            user = User.fromJson(uData, uid);
          }
        });
        if (user != null) {
          user?.profile?.signImage =
              await Utils.imageFromURL(user?.profile?.signImageURL);
          return user;
        }
      }
      throw RemoteException('Sai tài khoản hoặc mật khẩu');
    } catch (e) {
      throw e.toString();
    }
  }

  Future<DataSnapshot> getUserByUserName(String userName) async {
    try {
      return await refUsersDB.orderByChild('userName').equalTo(userName).once();
    } catch (e) {
      throw RemoteException('Đã xảy ra lỗi');
    }
  }

  Future<User?> addNewUserToDB(User model) async {
    try {
      final authUserName = await getUserByUserName(model.useName!);
      if (authUserName.exists) throw RemoteException('Tài khoản đã tồn tại');

      final uid = refUsersDB.push();
      model.profile?.id = uid.key;
      await uid.set(model.toJson());
      return model;
    } on RemoteException catch (e) {
      throw e.toString();
    } catch (e) {
      throw RemoteException('Thêm user thất bại');
    }
  }

  Future<void> updateUserOnDB(String id, Map<String, dynamic> data) async {
    try {
      return await refUsersDB.child(id).update(data);
    } catch (e) {}
    throw RemoteException('Cập nhật user thất bại');
  }

  Future<void> updateUseProfileOnDB(
      String id, Map<String, dynamic> data) async {
    try {
      return await refUsersDB.child(id).child('profile').update(data);
    } catch (e) {}
    throw RemoteException('Cập nhật user thất bại');
  }

  Future<void> removeUser(String id) async {
    print(id);
    try {
      await _removeStorageData(id);
      return await refUsersDB.child(id).remove();
    } catch (e) {
      print(e);
    }
    throw RemoteException('Xóa user thất bại');
  }

  /// upload image to report storage
  Future<String?> uploadImageToStorage(
      String uid, String imgName, Uint8List file) async {
    final parentRef = _refImageStorage.child(uid).child(imgName);
    try {
      final uploadTask = await parentRef.putData(file);
      return uploadTask.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// remove report storage data
  Future<void> _removeStorageData(String uid) async {
    final imagesRef = await _refImageStorage.child(uid).listAll();

    imagesRef.items.forEach((element) {
      element.delete();
    });
  }
}
