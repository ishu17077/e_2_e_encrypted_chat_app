import 'dart:typed_data';

import 'package:e_2_e_encrypted_chat_app/server_functions/get_messages.dart';
import 'package:flutter/material.dart';

import 'package:e_2_e_encrypted_chat_app/models/message.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ChatSend extends StatelessWidget {
  String contents = '';
  String sender = '';
  String recipient = '';
  Message message = Message(
      // chatId: '', //! ChatId should be unique
      recipientEmail: 'Lololol',
      time: DateTime.now(),
      contents: '',
      senderEmail: 'Legends of Sex',
      iv: Uint8List(16),
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
              hintText: "recipient",
            ),
            onChanged: (value) {
              recipient = value;
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
              message.senderEmail = sender;
              message.recipientEmail = recipient;

              GetMessages().sendMessage(message);
            },
            child: const Text('Send Text'),
          ),
        ],
      ),
    );
  }
}
