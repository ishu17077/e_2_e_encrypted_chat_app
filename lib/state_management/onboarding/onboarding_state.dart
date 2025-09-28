import 'package:equatable/equatable.dart';
import 'package:chat/chat.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {
  final User user;
  const OnboardingSuccess(this.user);
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class OnboardingFailure extends OnboardingState {}
