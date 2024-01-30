import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String userFCMTokenKey = 'FCM_TOKEN';

  // FCM Token
  static Future<void> setFCMToken(String url) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(userFCMTokenKey, url);
  }

  static Future<String?> getFCMToken() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(userFCMTokenKey);
  }

  static Future<void> removeFCMToken() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(userFCMTokenKey, '');
  }
}
