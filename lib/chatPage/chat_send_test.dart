import 'package:e_2_e_encrypted_chat_app/serverFunctions/get_messages.dart';
import 'package:flutter/material.dart';

import 'package:e_2_e_encrypted_chat_app/models/message.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ChatSend extends StatelessWidget {
  String contents = '';
  String sender = '';
  String recepient = '';
  Message message = Message(
      recepient: 'Lololol',
      time: DateTime.now(),
      contents: '',
      sender: 'Legends of Sex',
      isSeen: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Sender",
            ),
            onChanged: (value) {
              sender = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: "Recepient",
            ),
            onChanged: (value) {
              recepient = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: "Contents",
            ),
            onChanged: (value) {
              contents = value;
            },
          ),
          TextButton(
            onPressed: () {
              message.contents = contents;
              message.sender = sender;
              message.recepient = recepient;

              GetMessages().sendMessage(message);
            },
            child: const Text('Send Text'),
          ),
        ],
      ),
    );
  }
}
