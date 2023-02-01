import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AddNewUser {
  Future<User?> get signedInUser async {
    //! Nullable getter
    final user = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
        // print(user.email);
      }
    });
    return FirebaseAuth.instance.currentUser;
    // return await user.asFuture().asStream().first;
    // final userCredential = await FirebaseAuth.instance.signInWithCredential(const AuthCredential(providerId: 'google.com', signInMethod: 'password'));
    // final user = userCredential.user;
    // print(user?.uid);
  }

  Future<UserCredential> get signInWithGoogle async {
    //! Trigger the authentication flow
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    //! Obtain the auth details from the request
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;
    //? Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    //! Once signed in returning the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void userWithEmalandPassword(String email, String password) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
