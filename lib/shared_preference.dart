import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_peaks_library_export_extension/session_model.dart';

class SharedPref {
  static const String userFCMTokenKey = 'FCM_TOKEN';
  static const String sessionList = 'SESSION_LIST';
  static const String ftpKey = 'FTP';

  // FCM Token
  static Future<void> setFCMToken(String token) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(userFCMTokenKey, token);
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

  // FTP
  static Future<void> setFTP(int ftp) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt(ftpKey, ftp);
  }

  static Future<int?> getFTP() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt(ftpKey);
  }

  static Future<void> removeFTP() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt(ftpKey, 0);
  }

  // Session List
  static Future<void> setSessionList(SessionList session) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionList, session.toRawJson());
  }

  static Future<SessionList?> getSessionList() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    return SessionList.fromRawJson(prefs.getString(sessionList) ?? '{}');
  }

  static Future<void> removeSessionList() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(sessionList, '');
  }
}
