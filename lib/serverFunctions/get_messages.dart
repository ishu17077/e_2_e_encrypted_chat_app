import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class GetMessages {
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

  static void addUser(User user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("users").add(user.toJson()).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}, ${doc.path}'));
  }
}
