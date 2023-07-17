// ignore_for_file: must_be_immutable

import 'package:e_2_e_encrypted_chat_app/serverFunctions/add_new_chat.dart';
import 'package:flutter/material.dart';

import '../models/chat.dart';

// ignore: camel_case_types
class Chat_Add extends StatelessWidget {
  String chatWith = 'sAx';
  int unreadMessages = 69;
  String lastMessage = 'Good Luck Mate';
  DateTime lastTime = DateTime.now();
  Chat chat = Chat(
    chatWith: '',
    lastTime: DateTime.now(),
    lastMessage: '',
    unreadMessages: 69,
  );

  Chat_Add({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "chat_with",
            ),
            onChanged: (value) {
              chatWith = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: "last_message",
            ),
            onChanged: (value) {
              lastMessage = value;
            },
          ),
          TextButton(
            onPressed: () {
              chat.chatWith = chatWith;
              chat.unreadMessages = unreadMessages;
              chat.lastMessage = lastMessage;
              chat.lastTime = lastTime;
              AddChat().addNewChat(chat);
            },
            child: const Text('Send Text'),
          ),
        ],
      ),
    );
  }
}
