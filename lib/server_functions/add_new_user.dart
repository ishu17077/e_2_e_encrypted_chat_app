import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secuchat/encryption/encryption_methods.dart';
import 'package:secuchat/notifications/firebase_api.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secuchat/models/user.dart' as my_user;

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class AddNewUser {
  static User? get signedInUser {
    //! Nullable getter
    final user = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        // print(user.email);
      }
    });
    user.onData((data) {
      debugPrint(data?.uid);
      debugPrint("Display Name: ${data?.displayName}");
      debugPrint("Email: ${data?.email}");
    });
    return _auth.currentUser;
    // return FirebaseAuth.instance.currentUser;
    // return await user.asFuture().asStream().first;
    // final userCredential = await FirebaseAuth.instance.signInWithCredential(const AuthCredential(providerId: 'google.com', signInMethod: 'password'));
    // final user = userCredential.user;
    // print(user?.uid);
  }

  static Future<String?> addUserToDatabase(my_user.User user) async {
    String _error = 'Success';

    final QuerySnapshot checkExists = await _firestore
        .collection('users')
        .where('email_address', isEqualTo: signedInUser!.email)
        .get();
    final List<DocumentSnapshot> exists = checkExists.docs;
    if (exists.isEmpty) {
      await _firestore.collection('users').add(user.toJson());
    } else {
      var collection = _firestore.collection('users');
      var collectionBetichod = await collection
          .where('email_address', isEqualTo: signedInUser?.email)
          .get();
      collection.doc(collectionBetichod.docs.first.id).update(user.toJson());

      print("User already Exists");
    }
    if (user != null) {
      await FirebaseApi().initNotifications();
    } //? initialize notification for them
    return _error;
  }

  Future<UserCredential> get signInWithGoogle async {
    //! Trigger the authentication flow
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn.instance.authenticate();
    //! Obtain the auth details from the request
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    //? Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    //! Once signed in returning the UserCredential

    final UserCredential user = await _auth.signInWithCredential(credential);
    final publicKeyJwb = await EncryptionMethods.generateAndStoreKeysJwk();
    my_user.User userDatabase = my_user.User(
        emailAddress: user.user!.email!,
        publicKeyJwb: publicKeyJwb!,
        username: user.user!.displayName,
        photoUrl: user.user?.photoURL ??
            'https://marmelab.com/images/blog/ascii-art-converter/homer.png',
        lastseen: DateTime.now());
    await addUserToDatabase(userDatabase);

    return user;
  }

  static Future<my_user.User?> createUserWithEmailandPassword(
      String name, String email, String password) async {
    final UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final publicKeyJwb = await EncryptionMethods.generateAndStoreKeysJwk();
      my_user.User userDatabase = my_user.User(
          emailAddress: credential.user!.email!,
          username: name,
          publicKeyJwb: publicKeyJwb!,
          photoUrl: credential.user?.photoURL ??
              'https://marmelab.com/images/blog/ascii-art-converter/homer.png',
          lastseen: DateTime.now());

      await addUserToDatabase(userDatabase);
      return userDatabase;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }
}

logOut() async {
  await FirebaseAuth.instance.signOut();
}
