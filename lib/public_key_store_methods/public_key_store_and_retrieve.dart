import 'package:shared_preferences/shared_preferences.dart';

class PublicKeyStoreAndRetrieve {
  static Future<void> savePublicKeyForUserEmail(SharedPreferences prefs,
      {required String email_address, required String publicKey}) async {
    prefs.setString(email_address, publicKey);
  }

  static Future<String?> retrievePublicKeyForUserEmail(SharedPreferences prefs,
      {required String email_address}) async {
    try {
      return prefs.getString(email_address);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
