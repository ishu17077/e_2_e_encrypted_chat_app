// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/reusable_widgets/app_back_button.dart';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/sign_up_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/chat_with_page.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';

// ignore: camel_case_types
class ChatAdd extends StatefulWidget {
  const ChatAdd({super.key});

  @override
  State<ChatAdd> createState() => _ChatAddState();
}

class _ChatAddState extends State<ChatAdd> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String chatWith = 'sAx';

  int unreadMessages = 69;

  bool? chatExists;
  bool hasData = false;

  String lastMessage = 'Good Luck Mate';
  Stream<QuerySnapshot>? _snapshots;

  DateTime lastTime = DateTime.now();

  final signedInUser = AddNewUser.signedInUser;
  late CollectionReference collectionReference;
  @override
  void initState() {
    // TODO: implement initState
    if (signedInUser == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpPage()));
    }
    collectionReference = _firebaseFirestore.collection('chats');

    _snapshots = _firebaseFirestore
        .collection('users')
        .where('email_address', isNotEqualTo: signedInUser?.email)
        .snapshots();

    super.initState();
  }

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
          stream: _snapshots,
          builder: (context, snapshots) {
            if (snapshots.hasError) {
              return const Center(
                  child: Text('Server error or no internet connection'));
            } else if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            Future<void> future = Future(() => null);
            List<Widget> widgets =
                snapshots.data!.docs.map((DocumentSnapshot documentSnapshot) {
              Map<String, dynamic> userMap =
                  documentSnapshot.data()! as Map<String, dynamic>;
              User user = User.fromJson(userMap);

              Chat chat = Chat(
                  photoUrls: [
                    signedInUser?.photoURL ??
                        'https://marmelab.com/images/blog/ascii-art-converter/homer.png',
                    user.photoUrl ??
                        'https://marmelab.com/images/blog/ascii-art-converter/homer.png'
                  ],
                  belongsToEmails: [signedInUser!.email!, user.emailAddress],
                  chatId: '${signedInUser?.email!}${user.emailAddress}',
                  chatNames: [signedInUser?.displayName, user.username]);
              future = chatIdExists(
                      '${signedInUser!.email!}${user.emailAddress}',
                      "${user.emailAddress}${signedInUser!.email!}")
                  .then((value) {
                if (value != null) {
                  chat.chatId = value;
                  chatExists = true;
                } else {
                  chatExists = false;
                }
              });

              return ListTile(
                tileColor: kBackgroundColor,
                leading: CircleAvatar(
                  backgroundColor: kSexyTealColor,
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
                onTap: () {
                  // ignore: use_build_context_synchronously
                  if (chatExists != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatWithPage(
                                  chatStore: chat,
                                  chatExists: chatExists!,
                                  chatName: user.username,
                                  senderEmail: signedInUser!.email!,
                                  recepientEmail: user.emailAddress!,
                                )));
                  }
                },
                enabled: true,
                enableFeedback: true,
              );
            }).toList();
            return FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                        "Error connecting to server...check your internet connection");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: widgets,
                  );
                });
          },
        ));
  }

  Future<String?> chatIdExists(String chatId1, String chatId2) async {
    final QuerySnapshot result1 = await collectionReference
        .where('chat_id', whereIn: [chatId1, chatId2]).get();
    final List<DocumentSnapshot> documents1 = result1.docs;

    if (documents1.isNotEmpty) {
      return result1.docs.single.get('chat_id');
    }

    return null;
  }
}
