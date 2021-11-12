import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/utils/commons/shared_preferences_keys.dart';
import 'package:electricity_manager/utils/helpers/session/shared_pref_manager.dart';

class SessionPref {
  static void saveSession(
      {required String accessToken}) {
    var preferencesManager = getIt.get<SharedPreferencesManager>();
    preferencesManager.putString(SharedPrefsKeys.uid, accessToken);
  }

  static String? getAccessToken() =>
      getIt.get<SharedPreferencesManager>().getString(SharedPrefsKeys.uid);

  static bool isSessionValid() {
    try {
      return getIt
          .get<SharedPreferencesManager>()
          .getString(SharedPrefsKeys.uid)
          ?.isNotEmpty ==
          true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearUserData() async {
    await getIt.get<SharedPreferencesManager>().clear();
  }
}