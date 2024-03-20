import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption_methods.dart';
import 'package:e_2_e_encrypted_chat_app/main.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

mixin ExistingUser {
  static Future<User> signInExistingUserWithEmailandPassword(
      String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }

    final publicKey = await EncryptionMethods.generateAndStoreKeysJwk();
    User? user;
    await FirebaseFirestore.instance
        .collection('users')
        .where('email_address', isEqualTo: credential!.user!.email!)
        .get()
        .then((snapshots) {
      var userDoc = snapshots.docs.first;
      FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .update({'public_key_jwb': publicKey!});
      user = User.fromJson(userDoc.data() as Map<String, dynamic>) ;
    });

    return user!;
  }
}
