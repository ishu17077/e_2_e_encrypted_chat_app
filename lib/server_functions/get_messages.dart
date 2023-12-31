import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';

import 'package:e_2_e_encrypted_chat_app/models/message.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMessages {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

  static Future<void> addUser(User user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("users").add(user.toJson()).then(
        (DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}, ${doc.path}'));
  }

  Future sendMessage(Message message) async {
    await _db
        .collection("messages")
        .add(message.toJson())
        .then((DocumentReference doc) {
      debugPrint('DocumentSnapshot added  with ID: ${doc.id}, ${doc.path}');
      return _db.collection("messages").get();
    });
  }

  Future<bool> setData(String key, String value) async {
    await _prefs.then((prefs) {
      prefs.setString(key, value).whenComplete(() => true);
    });
    return false;
  }

  Future<String?> getData(String key) async {
    await _prefs.then((prefs) {
      return (prefs.getString(key));
    });
    return null;
  }

  // static List<Message> forHomeScreen(List<Message> messages) {
  //   for (int i = 0; i < messages.length; i++) {
  //     for (int j = i + 1; j < messages.length; j++) {
  //       if (j > i) {
  //         break;
  //       }  //? My first lovely ineffecient piece of sh*t lol
  //       if (messages[i].senderEmail == messages[j].senderEmail) {
  //         messages.remove(messages[i]);
  //       }
  //     }
  //   }
  //   return messages;
  // }
}
