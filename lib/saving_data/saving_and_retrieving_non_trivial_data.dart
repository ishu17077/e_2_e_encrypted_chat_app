import 'package:shared_preferences/shared_preferences.dart';

class SavingAndRetrievingNonTrivialData {
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

  static Future<void> saveMessages(SharedPreferences prefs,
      {required String email_address, required String messageContents}) async {
    List<String>? stringList = List.empty(growable: true);
    try {
      List<String>? savedMessagesList =
          prefs.getStringList('$email_address messages_Labadaba');
      if (savedMessagesList != null) {
        stringList.addAll(savedMessagesList);
      }
    } catch (e) {
      print(e.toString());
    }

    stringList.add(messageContents);
    prefs.setStringList('$email_address messages_Labadaba', stringList!);
  }

  static Future<List<String>?> retrieveMessages(
    SharedPreferences prefs, {
    required String email_address,
  }) async {
    try {
      return prefs.getStringList('$email_address messages_Labadaba');
    } catch (e) {
      return null;
    }
  }

  static Future<void> saveEmailsAsNotifId(
      {required SharedPreferences prefs,
      required int id,
      required String email_address}) async {
    prefs.setInt('$email_address notif_id_Labadaba', id);
  }

  static Future<int?> retrieveEmailNotifId(
      {required SharedPreferences prefs, required String email_address}) async {
    try {
      return prefs.getInt('$email_address notif_id_Labadaba');
    } catch (e) {
      return null;
    }
  }
}
