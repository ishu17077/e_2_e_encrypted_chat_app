part of 'typing_notif_bloc.dart';

sealed class TypingNotifEvent extends Equatable {
  const TypingNotifEvent();
  factory TypingNotifEvent.subscribed(User user,
          {required List<String> userWithChats}) =>
      Subscribed(user, userWithChats: userWithChats);
  factory TypingNotifEvent.sent(TypingEvent typingEvent) =>
      TypingEventSent(typingEvent);

  @override
  List<Object?> get props => [];
}

class Subscribed extends TypingNotifEvent {
  final User user;
  final List<String> userWithChats;
  const Subscribed(this.user, {required this.userWithChats});

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
