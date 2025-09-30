import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class IOnboardingRouter {
  void onSessionSuccess(BuildContext context, User me);
}

class OnboardingRouter implements IOnboardingRouter {
  final Function(User user) onSessionConnected;

  OnboardingRouter(this.onSessionConnected);

  @override
  void onSessionSuccess(BuildContext context, User me) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => onSessionConnected(me)),
      (Route<dynamic> route) => false,
    );
  }
}
