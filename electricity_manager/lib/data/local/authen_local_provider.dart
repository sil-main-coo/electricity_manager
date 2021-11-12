import 'package:electricity_manager/utils/commons/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenLocalProvider {
  Future<String?> getIdFromLocal() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final response = sharedPrefs.getString(SharedPrefsKeys.uid);

    return response;
  }

  Future<bool> saveTokenToLocal(String token) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.setString(SharedPrefsKeys.uid, token);
  }

  Future<bool> removeTokenFromLocal() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    return await sharedPrefs.remove(SharedPrefsKeys.uid);
  }
}
