import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart' as myuser;

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
      print(data?.uid);
      print("Display Name: ${data?.displayName}");
      print("Email: ${data?.email}");
    });
    return FirebaseAuth.instance.currentUser;
    // return FirebaseAuth.instance.currentUser;
    // return await user.asFuture().asStream().first;
    // final userCredential = await FirebaseAuth.instance.signInWithCredential(const AuthCredential(providerId: 'google.com', signInMethod: 'password'));
    // final user = userCredential.user;
    // print(user?.uid);
  }

  static Future<String?> addUserToDatabase(myuser.User user) async {
    String _error = '';
    final _firestore = FirebaseFirestore.instance;
    final QuerySnapshot checkExists = await _firestore
        .collection('users')
        .where('email_address', isEqualTo: signedInUser?.email)
        .get();
    final List<DocumentSnapshot> exists = checkExists.docs;
    if (exists.length == 0) {
      await _firestore
          .collection('users')
          .add(user.toJson())
          .onError((error, stackTrace) {
        print(error.toString());
        _error = error.toString();
        throw Exception();
      });
    }

    return _error;
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
    final UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(credential);
    myuser.User userDatabase = myuser.User(
        emailAddress: user.user!.email,
        username: user.user!.displayName,
        photoUrl: user.user?.photoURL ??
            'https://marmelab.com/images/blog/ascii-art-converter/homer.png',
        lastseen: DateTime.now());
    addUserToDatabase(userDatabase);
    return user;
  }

  static Future<String?> createUserWithEmailandPassword(
      String name, String email, String password) async {
    final UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      myuser.User userDatabase = myuser.User(
          emailAddress: credential.user!.email,
          username: credential.user!.displayName,
          photoUrl: credential.user?.photoURL ??
              'https://marmelab.com/images/blog/ascii-art-converter/homer.png',
          lastseen: DateTime.now());
      addUserToDatabase(userDatabase);
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      return (e.toString());
    }
    return null;
  }
}

logOut() async {
  await FirebaseAuth.instance.signOut();
}
