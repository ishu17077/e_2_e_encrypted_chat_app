import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/chat_pill.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/chat_text_field.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';
import 'package:e_2_e_encrypted_chat_app/models/message.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_chat.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatWithPage extends StatefulWidget {
  String? chatName;
  Chat chat;
  bool chatExists;
  String senderEmail;
  String recepientEmail;
  DateTime? lastOnline = DateTime.tryParse('19700101');

  ChatWithPage({
    super.key,
    this.chatName = '',
    required this.senderEmail,
    required this.recepientEmail,
    this.chatExists = true,
    required this.chat,
    this.lastOnline,
  });

  @override
  State<ChatWithPage> createState() => _ChatWithPageState();
}

class _ChatWithPageState extends State<ChatWithPage> {
  late User? signedInUser;
  Message? previousMessage;
  final AddNewChat _addNewChat = AddNewChat();
  OverlayEntry? sticky;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _mystream;
  // final GlobalKey stickeyKey = GlobalKey();
  @override
  void initState() {
    signedInUser = AddNewUser.signedInUser;
    _mystream = _firestore
        .collection('messages')
        .where('chat_id', isEqualTo: widget.chat.chatId)
        .orderBy('time')
        .snapshots();
    //! _mystream was seperately assigned as it was changing with everytime something happens like a keyboard pop up lol
    // if (sticky != null) {
    //   sticky?.remove();
    // }
    // sticky = OverlayEntry(
    //   builder: (context) => stickyBuilder(),
    // );

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Overlay.of(context).insert(sticky!);
    // });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // sticky?.remove();

    // stickeyKey.currentState?.dispose();
    super.dispose();
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ignore: prefer_const_constructors
            CircleAvatar(
              backgroundColor: kSexyTealColor,
              backgroundImage: NetworkImage(widget.chat.belongsToEmails.first !=
                      signedInUser!.email
                  ? widget.chat.photoUrls.first ??
                      'https://marmelab.com/images/blog/ascii-art-converter/homer.png'
                  : widget.chat.photoUrls.last ??
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
        padding: const EdgeInsets.only(top: 0.0, bottom: 7.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _mystream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text(
                  "There's an error processing this chat...check again later");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                ListView(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  children: snapshot.data!.docs.reversed
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> messageMap =
                        document.data()! as Map<String, dynamic>;

                    Message message = Message.fromJson(messageMap);
                    message.id = document.id;
                    if (message.senderEmail != signedInUser!.email &&
                        message.isSeen == false) {
                      _firestore
                          .collection('messages')
                          .doc(message.id)
                          .update({"is_seen": true});
                    }
                    bool noMarginRequired =
                        message.senderEmail == previousMessage?.senderEmail;
                    previousMessage = message;

                    return ChatPill(
                      text: message.contents,
                      isLastMessage: snapshot.data!.docs.last.id == document.id
                          ? true
                          : false,
                      // contextKey: stickeyKey,
                      isSeen: message.isSeen,
                      isMe: _isMe(
                        message.senderEmail,
                        signedInUser!.email!,
                      ),
                      noMaginRequired: noMarginRequired,
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ChatTextField(
                    onSendButtonPressed: (String contents) {
                      if (contents.isNotEmpty) {
                        Message message = Message(
                            recepientEmail: widget.recepientEmail,
                            time: DateTime.now(),
                            chatId: widget.chat.chatId,
                            senderEmail: widget.senderEmail,
                            contents: contents,
                            isSeen: false);
                        if (widget.chatExists == false) {
                          _addNewChat.addNewChat(widget.chat);
                        }
                        _firestore.collection('messages').add(message.toJson());
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget stickyBuilder() {
  //   return Builder(
  //     builder: (context) {
  //       final keyContext = stickeyKey.currentContext;
  //       if(keyContext != null){
  //         final b
  //       }
  //     },
  //   );
  // }

  bool _isMe(String sender, String signedInUserEmail) {
    bool isMe = sender == signedInUserEmail ? true : false;
    return isMe;
  }
}
