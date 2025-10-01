import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:secuchat/cache/local_cache.dart';
import 'package:secuchat/state_management/onboarding/onboarding_state.dart';
import 'package:secuchat/viewmodels/auth/auth_view_model.dart';
import 'package:secuchat/viewmodels/auth/email_sign_in_view_model.dart';
import 'package:secuchat/viewmodels/auth/google_sign_in_view_model.dart';

enum AuthType { google, email }

class OnboardingCubit extends Cubit<OnboardingState> {
  final AuthViewModel _authViewModel;

  //TODO: Impl Image uploader

  OnboardingCubit(this._authViewModel) : super(OnboardingInitial());

  Future<void> connect(User user, {AuthType authType = AuthType.email}) async {
    emit(OnboardingLoading());
    //TODO: impl photo
    _authViewModel.isSignedIn.listen((isSignedIn) async => isSignedIn
        ? await _updateUserToOnline(user)
        : await _updateUserToOffline(user));
  }

  Future<void> signUp(User user) async {}

  Future<void> signIn() async {}

  Future<void> _updateUserToOnline(User user) async {
    emit(OnboardingLoading());
    user.active = true;
    user.lastSeen = DateTime.now();
    try {
      await _authViewModel.connectUser(user);
    } catch (e) {
      emit(OnboardingFailure());
    }
  }

  Future<void> _updateUserToOffline(User user) async {
    emit(OnboardingLoading());
    user.active = false;
    user.lastSeen = DateTime.now();
    try {
      await _authViewModel.disconnectUser(user);
    } catch (e) {
      emit(OnboardingFailure());
    }
  }
}
