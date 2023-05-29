import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class ExistingUser {
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
    return User(
      emailAddress: credential?.user?.email ?? '',
      username: credential?.user?.displayName ?? '',
      photoUrl: '',
      active: false,
      lastseen: DateTime.now(),
    );
  }
}
