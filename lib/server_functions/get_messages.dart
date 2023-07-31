import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';

import 'package:e_2_e_encrypted_chat_app/models/message.dart';

class GetMessages {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

  static void addUser(User user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("users").add(user.toJson()).then(
        (DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}, ${doc.path}'));
  }

  Future sendMessage(Message message) async {
    await db
        .collection("messages")
        .add(message.toJson())
        .then((DocumentReference doc) {
      print('DocumentSnapshot added  with ID: ${doc.id}, ${doc.path}');
      return db.collection("messages").get();
    });
  }

  static List<Message> forHomeScreen(List<Message> messages) {
    for (int i = 0; i < messages.length; i++) {
      for (int j = i + 1; j < messages.length; j++) {
        if (j > i) {
          break;
        }
        if (messages[i].senderEmail == messages[j].senderEmail) {
          messages.remove(messages[i]);
        }
      }
    }
    return messages;
  }
}
