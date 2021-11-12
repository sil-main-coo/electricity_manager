import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/utils/error/remote_exception.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRemoteProvider {
  final refUsersDB = FirebaseDatabase.instance.reference().child('users');

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
        if (user != null) return user;
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

  Future<void> removeUser(String id) async {
    try {
      return await refUsersDB.child(id).remove();
    } catch (e) {}
    throw RemoteException('Xóa user thất bại');
  }
}
