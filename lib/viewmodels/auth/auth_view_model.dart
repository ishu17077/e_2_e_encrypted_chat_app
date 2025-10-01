import 'dart:async';

import 'package:chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/widgets.dart';
import 'package:secuchat/cache/local_cache.dart';

class AuthViewModel {
  final IUserService _userService;
  final ILocalCache _localCache;
  final firebaseAuth.FirebaseAuth auth;

  const AuthViewModel(this.auth, this._userService, this._localCache);

  User? get signedInUser {
    User? user;
    if (auth.currentUser != null) {
      return null;
    }
    try {
      final map = _localCache.fetch("USER");
      if (map.isEmpty) {
        return null;
      }
      user = User.fromJSON(map);
    } catch (e) {
      signOut();
      return null;
    }
    return user;
  }

  Stream<bool> get isSignedIn {
    return auth.authStateChanges().map(
      (user) {
        return user != null ? true : false;
      },
    );
  }

  Future<User?> connectUser(User user) async {
    user.active = true;
    user.lastSeen = DateTime.now();
    try {
      final connectedUser = await _userService.connect(user);
      await _localCache.save("USER", data: connectedUser.toJSON());
      return connectedUser;
    } catch (e) {
      return null;
    }
  }

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

  Future<void> signOut() async {
    final user = User.fromJSON(_localCache.fetch("USER"));
    _localCache.clear("USER");
    await disconnectUser(user);
    await auth.signOut();
  }
}
