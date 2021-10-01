import 'package:electricity_manager/commons/pref_key.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/utils/helpers/session/shared_pref_manager.dart';

class SessionPref {
  static void saveSession(
      {required String accessToken, required String refreshToken}) {
    var preferencesManager = getIt.get<SharedPreferencesManager>();
    preferencesManager.putString(keyAccessToken, accessToken);
    preferencesManager.putString(keyRefreshToken, refreshToken);
  }

  static String? getAccessToken() =>
      getIt.get<SharedPreferencesManager>().getString(keyAccessToken);

  static String? getRefreshToken() =>
      getIt.get<SharedPreferencesManager>().getString(keyRefreshToken);

  static bool isSessionValid() {
    try {
      return getIt
          .get<SharedPreferencesManager>()
          .getString(keyAccessToken)
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