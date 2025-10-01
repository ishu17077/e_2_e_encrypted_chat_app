import 'package:chat/chat.dart' as chat;
import 'package:secuchat/viewmodels/auth/auth_view_model.dart';

class EmailSignInViewModel extends AuthViewModel {
  EmailSignInViewModel(super.auth, super.userService, super.localCache);

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final userCreds =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (userCreds.user == null) {
      throw Exception("Unable to sign In!");
    }

    final chat.User user = chat.User(
        name: '',
        email: '',
        username: '',
        lastSeen: DateTime.now(),
        active: true,
        id: userCreds.user!.uid);
    super.connectUser(user);
  }

  Future<void> signUp(
      {required String name,
      required String username,
      required String email,
      required String password,
      String? photoUrl}) async {
    final userCreds = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (userCreds.user == null) {
      throw Exception("Unable to fetch user!");
    }

    final chat.User user = chat.User(
        name: name,
        email: email,
        username: username,
        lastSeen: DateTime.now(),
        active: true,
        photoUrl: photoUrl,
        id: userCreds.user!.uid);

    super.connectUser(user);
  }
}
