part of 'typing_notif_bloc.dart';

sealed class TypingNotifEvent extends Equatable {
  const TypingNotifEvent();

  @override
  List<Object?> get props => [];
}

class Subscribed extends TypingNotifEvent {
  final User user;
  const Subscribed(this.user);

  @override
  List<Object?> get props => [user];
}

class TypingEventSent extends TypingNotifEvent {
  final TypingEvent typingEvent;
  const TypingEventSent(this.typingEvent);

  @override
  List<Object?> get props => [typingEvent];
}

class _TypingEventReceived extends TypingNotifEvent {
  final TypingEvent typingEvent;
  const _TypingEventReceived(this.typingEvent);

  @override
  List<Object?> get props => [typingEvent];
}
