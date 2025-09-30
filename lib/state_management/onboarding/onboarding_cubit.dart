import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:secuchat/cache/local_cache.dart';
import 'package:secuchat/state_management/onboarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final FirebaseAuth _firebaseAuth;
  final IUserService _userService;
  final ILocalCache _localCache;
  //TODO: Impl Image uploader

  OnboardingCubit(this._userService, this._firebaseAuth, this._localCache)
      : super(OnboardingInitial());

  Future<void> connect(User user) async {
    emit(OnboardingLoading());
    //TODO: impl photo'
    _firebaseAuth.authStateChanges().listen((fUser) async => fUser != null
        ? await _updateUserToOnline(user)
        : await _updateUserToOffline(user));
  }

  Future<void> _updateUserToOnline(User user) async {
    user.active = true;
    user.lastSeen = DateTime.now();
    try {
      final connectedUser = await _userService.connect(user);
      await _localCache.save("USER", data: connectedUser.toJSON());
      emit(OnboardingSuccess(connectedUser));
    } catch (e) {
      emit(OnboardingFailure());
    }
  }

  Future<void> _updateUserToOffline(User user) async {
    user.active = false;
    user.lastSeen = DateTime.now();
    try {
      await _userService.disconnect(user);
      await _localCache.save("USER", data: user.toJSON());
    } catch (e) {
      emit(OnboardingFailure());
    }
  }
}
