import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class GetMessages {
  var db = FirebaseFirestore.instance;
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

  void addUser() async {
    db.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}, ${doc.path}'));
  }
}
