import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:secuchat/ui/pages/chatPage/add_new_chat/new_chat.dart';

abstract class IHomeRouter {
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {String? chatId});
  Future<void> onShowNewChatUi(BuildContext context, User me);
}

class HomeRouter implements IHomeRouter {
  final Widget Function(User receiver, User me, {String? chatId})
      showMessageThread;
  final Widget Function(User me) showNewChatUi;
  HomeRouter(this.showMessageThread, this.showNewChatUi);

  @override
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {String? chatId}) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => showMessageThread(receiver, me, chatId: chatId)));
  }

  @override
  Future<void> onShowNewChatUi(BuildContext context, User me) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => showNewChatUi(me),
        ));
  }
}
