import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/chat_pill.dart';
import 'package:e_2_e_encrypted_chat_app/models/message.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  late User? signedInUser;
  Message? previousMessage;
  @override
  void initState() {
    signedInUser = AddNewUser.signedInUser;

    super.initState();
  }

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
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('messages')
              .where('chat_id', isEqualTo: widget.chatId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text(
                  "There's an error processing this chat...check again later");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              physics: const BouncingScrollPhysics(),
              children:
                  snapshot.data!.docs.reversed.map((DocumentSnapshot document) {
                Map<String, dynamic> messageMap =
                    document.data() as Map<String, dynamic>;

                Message message = Message.fromJson(messageMap);
                message.id = document.id;
                bool noMarginRequired =
                    message.senderEmail == previousMessage?.senderEmail;
            
                previousMessage = message;
                return ChatPill(
                  text: message.contents,
                  isSeen: message.isSeen,
                  isMe: _isMe(
                    message.senderEmail,
                    signedInUser?.email ?? 'randomleloemail@gmail.com',
                  ),
                  noMaginRequired: noMarginRequired,
                );
              }).toList(),
            );
          },
        ),
        // child: Column(
        //   children: [
        //     ChatPill(
        //       text:
        //           'tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar tapar',
        //       isMe: false,
        //       isSeen: true,
        //     ),
        //     ChatPill(
        //       text: 'Chup be bkl',
        //       isMe: true,
        //       isSeen: true,
        //     ),
        //     ChatPill(
        //       text: 'Bahut Bolta ha',
        //       isMe: true,
        //       isSeen: true,
        //       isLastMessageFromUs: true,
        //     ),
        //     ChatPill(
        //       text: 'Ok',
        //       isMe: false,
        //       isSeen: true,
        //     ),
        //   ],
        // ),
      ),
    );
  }

  bool _isMe(String sender, String signedInUserEmail) {
    bool isMe = sender == signedInUserEmail ? true : false;
    return isMe;
  }
}
