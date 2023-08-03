// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/reusable_widgets/app_back_button.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/chat_with_page.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';

// ignore: camel_case_types
class ChatAdd extends StatelessWidget {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String chatWith = 'sAx';
  int unreadMessages = 69;
  String lastMessage = 'Good Luck Mate';
  DateTime lastTime = DateTime.now();
  final signedInUser = AddNewUser.signedInUser;

  ChatAdd({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          leading: const AppBackButton(),
          elevation: 0,
          title: const Text(
            "People you can talk to",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: kBackgroundColor,
        body: StreamBuilder<QuerySnapshot>(
          stream: _firebaseFirestore
              .collection('users')
              .where('email_address', isNotEqualTo: signedInUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                  child: Text('Server error or no internet connection'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                Map<String, dynamic> userMap =
                    documentSnapshot.data()! as Map<String, dynamic>;
                User user = User.fromJson(userMap);

                return ListTile(
                  tileColor: kBackgroundColor,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl ??
                        'https://marmelab.com/images/blog/ascii-art-converter/homer.png'),
                  ),
                  title: Text(
                    user.username ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    user.emailAddress ?? '**No Email**',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () async {
                    bool chatExists;

                    Chat chat = Chat(
                        chatWithEmail: user.emailAddress ?? 'test@testmail.com',
                        unreadMessages: 0,
                        lastOnline: DateTime.now(),
                        photoUrls: [
                          signedInUser?.photoURL ??
                              'https://marmelab.com/images/blog/ascii-art-converter/homer.png',
                          user.photoUrl ??
                              'https://marmelab.com/images/blog/ascii-art-converter/homer.png'
                        ],
                        belongsToEmails: [
                          signedInUser!.email!,
                          user.emailAddress
                        ],
                        chatId: '${signedInUser?.email!}${user.emailAddress}',
                        chatNames: [signedInUser?.displayName, user.username]);

                    if (await chatIdExists(chat.chatId)) {
                      chatExists = true;
                    } else if (await chatIdExists(
                        '${user.emailAddress}${signedInUser?.email!}')) {
                      chatExists = true;
                      chat.chatId =
                          '${user.emailAddress}${signedInUser?.email!}';
                      //? All i did was i checked whether the chat id is opposite if it is please don't create a new chat with previous hardcoded chat.chatId id use the fucking old one
                    } else {
                      chatExists = false;
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatWithPage(
                                chat: chat,
                                chatExists: chatExists,
                                chatName: user.username,
                                senderEmail: signedInUser!.email!,
                                recepientEmail: user.emailAddress!,
                                chatId: chat.chatId)));
                  },
                  enabled: true,
                  enableFeedback: true,
                );
              }).toList(),
            );
          },
        ));
  }

  Future<bool> chatIdExists(String chatId) async {
    final QuerySnapshot result = await _firebaseFirestore
        .collection('chats')
        .where('chat_id', isEqualTo: chatId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    // ignore: prefer_is_empty
    if (documents.length > 0) {
      return true;
    }
    return false;
  }
}
