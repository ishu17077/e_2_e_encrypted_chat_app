import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/chat_pill.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';

class ChatWithPage extends StatefulWidget {
  String? chatName;
  String? chatId;
  ChatWithPage({
    super.key,
    this.chatName = '',
    required this.chatId,
  });

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
            CircleAvatar(
              backgroundImage: const NetworkImage(
                  'https://marmelab.com/images/blog/ascii-art-converter/homer.png'),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Text(
              widget.chatName ?? '',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            ChatPill(
              text:
                  'tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar',
              isMe: false,
              isSeen: true,
            ),
            ChatPill(
              text: 'Chup be bkl',
              isMe: true,
              isSeen: true,
            ),
            ChatPill(
              text: 'Bahut Bolta ha',
              isMe: true,
              isSeen: true,
              isLastMessageFromUs: true,
            ),
            ChatPill(
              text: 'Ok',
              isMe: false,
              isSeen: true,
            ),
          ],
        ),
      ),
    );
  }
}
