import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secuchat/viewmodels/auth/auth_view_model.dart';
import 'package:chat/chat.dart' as chat;

class GoogleSignInViewModel extends AuthViewModel {
  final GoogleSignIn _googleSignIn;
  GoogleSignInViewModel(
      this._googleSignIn, super.auth, super.userService, super.localCache);

  Future<void> signIn() async {
    //TODO: call initialize
    try {
      await _googleSignIn.initialize();
      if (!_googleSignIn.supportsAuthenticate()) {
        throw Exception("Platform Incompatible");
      }
      final googleUser = await _googleSignIn.attemptLightweightAuthentication();
      if (googleUser == null) {
        return;
      }
      final googleClient =
          await googleUser.authorizationClient.authorizationForScopes([
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ]);
      final googleAuth = googleUser.authentication;

      final AuthCredential credentials = GoogleAuthProvider.credential(
          accessToken: googleClient!.accessToken, idToken: googleAuth.idToken);
      final userCreds = await super.auth.signInWithCredential(credentials);
      final chat.User user = chat.User(
          name: userCreds.user!.displayName ?? '',
          email: userCreds.user!.email!,
          username: userCreds.user!.email!.split("@").first,
          photoUrl: userCreds.user!.photoURL,
          lastSeen: DateTime.now(),
          id: userCreds.user!.uid);
      connectUser(user);
    } catch (e) {
      debugPrint("Sign in error ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await super.signOut();
  }
}
