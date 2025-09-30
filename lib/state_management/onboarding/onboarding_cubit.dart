import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:secuchat/cache/local_cache.dart';
import 'package:secuchat/state_management/onboarding/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IUserService _userService;
  final ILocalCache _localCache;
  //TODO: Impl Image uploader

  OnboardingCubit(this._userService, this._localCache)
      : super(OnboardingInitial());

  Future<void> connect(User user) async {
    emit(OnboardingLoading());
    user.active = true;
    user.lastSeen = DateTime.now();
    //TODO: impl photo
    try {
      final connectedUser = await _userService.connect(user);
      await _localCache.save("USER", data: connectedUser.toJSON());
      emit(OnboardingSuccess(connectedUser));
    } catch (e) {
      emit(OnboardingFailure());
    }
  }
}
