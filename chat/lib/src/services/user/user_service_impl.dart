import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserService implements IUserService {
  final FirebaseFirestore _firebaseFirestore;

  const UserService(this._firebaseFirestore);

  @override
  Future<User> connect(User user) async {
    var userMap = user.toJSON();

    final DocumentReference docRef = _firebaseFirestore
        .collection("users")
        .doc(user.id);

    await docRef.update(userMap);

    return _mapIdToUser(docRef.id, user);
  }

  @override
  Future<void> disconnect(User user) async {
    user.active = false;
    user.lastSeen = DateTime.now();
    Map<String, dynamic> userMap = user.toJSON();

    final DocumentReference docRef = _firebaseFirestore
        .collection("users")
        .doc(user.id);

    await docRef.update(userMap);
    _firebaseFirestore.terminate();
  }

  @override
  Future<User?> fetch(String id) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firebaseFirestore
        .collection("users")
        .doc(id)
        .get();
    if (doc.data() == null) {
      debugPrint("Unable to find user");
    }
    if (doc.data() == null) return null;
    return User.fromJSON(doc.data()!);
  }

  @override
  Future<List<User>> online() async {
    final userDocs = await _firebaseFirestore
        .collection("users")
        .where("active", isEqualTo: true)
        .get();

    List<User> users = userDocs.docChanges.map((element) {
      return User.fromJSON(
        element.doc.data() ??
            {
              "id": "Cannot_find_id",
              "name": "Name not found",
              "username": "Not found",
              "email": "N/A",
            },
      );
    }).toList();

    return users;
  }

  User _mapIdToUser(String id, User user) {
    return User.fromJSON({"id": id, ...user.toJSON()});
  }
}
