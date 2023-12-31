import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption_methods.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

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
    // final deriveKeys = await deriveKey(jwb.privateKey, jwb.publicKey);
    await FirebaseFirestore.instance
        .collection('users')
        .where('email_address', isEqualTo: credential!.user!.email!)
        .get()
        .then((snapshots) {
      snapshots.docs.first
          .data()
          .update('public_key_jwb', (value) => publicKey);
    });
    return User(
      emailAddress: credential.user!.email ?? '',
      username: credential.user!.displayName ?? '',
      photoUrl: '',
      publicKeyJwb: publicKey!,
      lastseen: DateTime.now(),
    );
  }
}
