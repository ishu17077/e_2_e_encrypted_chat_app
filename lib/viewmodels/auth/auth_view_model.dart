import 'package:chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/widgets.dart';
import 'package:secuchat/cache/local_cache.dart';

abstract class AuthViewModel {
  final IUserService _userService;
  final ILocalCache _localCache;
  final firebaseAuth.FirebaseAuth auth;

  const AuthViewModel(this.auth, this._userService, this._localCache);

  @protected
  firebaseAuth.User? get signedInUser {
    final user = auth.currentUser;
    return user;
  }

  @protected
  Future<bool> connectUser(User user) async {
    user.active = true;
    user.lastSeen = DateTime.now();
    try {
      await _userService.connect(user);
      await _localCache.save("USER", data: user.toJSON());
      return true;
    } catch (e) {
      return false;
    }
  }

  @protected
  Future<bool> disconnectUser(User user) async {
    user.active = true;
    user.lastSeen = DateTime.now();
    try {
      await _userService.disconnect(user);
      await _localCache.save("USER", data: user.toJSON());
      return true;
    } catch (e) {
      return false;
    }
  }

  @protected
  Future<void> signOut() async {
    final user = User.fromJSON(_localCache.fetch("USER"));
    await disconnectUser(user);
    await auth.signOut();
  }
}
