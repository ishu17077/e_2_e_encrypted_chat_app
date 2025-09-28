part of 'typing_notif_bloc.dart';

sealed class TypingNotifState extends Equatable {
  const TypingNotifState();
  @override
  List<Object?> get props => [];
}

class TypingInitial extends TypingNotifState {}

class TypingSentSuccess extends TypingNotifState {
  final TypingEvent typingEvent;

  const TypingSentSuccess(this.typingEvent);

  @override
  List<Object?> get props => [typingEvent];
}

class TypingReceivedSuccess extends TypingNotifState {
  final TypingEvent typingEvent;

  const TypingReceivedSuccess(this.typingEvent);

  @override
  List<Object?> get props => [typingEvent];
}
