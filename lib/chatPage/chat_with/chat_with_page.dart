import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/chat_pill.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';

class ChatWithPage extends StatefulWidget {
  const ChatWithPage({super.key});

  @override
  State<ChatWithPage> createState() => _ChatWithPageState();
}

class _ChatWithPageState extends State<ChatWithPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            opticalSize: 15,
            size: 15,
            color: Colors.white70,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kBackgroundColor,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ignore: prefer_const_constructors
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://marmelab.com/images/blog/ascii-art-converter/homer.png'),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            const Text(
              'Arun Mc',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          ChatPill(
            text:
                'tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar',
            isMe: true,
            isSeen: true,
          )
        ],
      ),
    );
  }
}
