import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/sign_up_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/add_new_chat/add_new_chat_page.dart';

import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/chat_with_page.dart';
import 'package:e_2_e_encrypted_chat_app/databases/chat_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:e_2_e_encrypted_chat_app/models/message_store.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

final _firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final ScrollController _scrollController = ScrollController();
  // CollectionReference<Map<String, dynamic>>? _collectionLastMessages;
  List<ChatStore>? chatList;
  int count = 0;
  bool shouldHideTextField = false;
  // ignore: non_constant_identifier_names
  ChatDatabaseHelper chatDatabaseHelper = ChatDatabaseHelper();
  final signedInUser = AddNewUser.signedInUser;
  @override
  void initState() {
    if (signedInUser == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpPage()));
    }
    updateListView();
    // chatDatabaseHelper.insertChat(ChatStore(
    //   belongsToEmail: 'belongsToEmail@sexyMail.com',
    //   photoUrl:
    //       'https://marmelab.com/images/blog/ascii-art-converter/homer.png',
    //   name: 'HolaBoi',
    //   mostRecentMessage: MessageStore(
    //       chatId: 1,
    //       recepientEmail: 'chomail@gomail.com',
    //       contents: 'Hey There',
    //       isSeen: true,
    //       senderEmail: 'belongsToEmail@sexyMail.com',
    //       time: DateTime.now()),
    // ));
    // print(json.encode(value));
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  // List<Message> messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          // controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              elevation: 0.0,
              collapsedHeight: 65,
              backgroundColor: kBackgroundColor,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 0.0, left: 8.0, right: 11.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Conversations",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          MaterialButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            color: kSexyTealColor.withOpacity(0.8),
                            elevation: 5,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: kBackgroundColor,
                                ),
                                Text(
                                  'Add New',
                                  style: TextStyle(
                                      color: kBackgroundColor, fontSize: 13),
                                ),
                              ],
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const ChatAdd()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                  // innerBoxIsScrolled
                  //     ? Container()
                  //     :
                ],
              ),
            )
          ],
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 0.0, left: 8.0, right: 11.0),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    fillColor: kTextFieldColor,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.teal,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: Colors.teal,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return chatTile(chatList![index], context);
                  },
                  itemCount: count,
                ),
              )

              // StreamBuilder<QuerySnapshot>(
              //   stream: _snapshotChats,
              //   builder: (BuildContext context,
              //       AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.hasError) {
              //       return const Text('Something Went wrong');
              //     } else if (snapshot.connectionState ==
              //         ConnectionState.waiting) {
              //       return const Expanded(
              //           child: Center(child: CircularProgressIndicator()));
              //     }
              //     // ignore: avoid_print
              //     print(
              //         "Signed in as email${FirebaseAuth.instance.currentUser?.email!} ");
              //     //! Hope you see the problem
              //     return Expanded(
              //       child: ListView(
              //         physics: const BouncingScrollPhysics(),
              //         children:
              //             snapshot.data!.docs.map((DocumentSnapshot document) {
              //           Map<String, dynamic> data =
              //               document.data()! as Map<String, dynamic>;
              //           Chat chat = Chat.fromJson(data);
              //           print("Chat id: ${chat.chatId}");
              //           return chatTile(chat, context);
              //         }).toList(),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // ListTile chatTile(Chat chat, BuildContext context) {
  //   this.chat = chat;
  //   return ListTile(
  //     tileColor: kBackgroundColor,
  //     leading: CircleAvatar(
  //       backgroundImage: NetworkImage(chat.belongsToEmails.first !=
  //               signedInUser?.email
  //           ? chat.photoUrls.first ??
  //               'https://marmelab.com/images/blog/ascii-art-converter/homer.png'
  //           : chat.photoUrls.last ??
  //               'https://marmelab.com/images/blog/ascii-art-converter/homer.png'),
  //     ),
  //     title: Text(
  //       chat.belongsToEmails.first != signedInUser?.email
  //           ? chat.chatNames.first ?? ''
  //           : chat.chatNames.last ?? '',
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //     subtitle: StreamBuilder<QuerySnapshot>(
  //       stream: _collectionLastMessages!
  //           .where('chat_id', isEqualTo: chat.chatId)
  //           .orderBy('time')
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return const Text("Could not load the last message...",
  //               style: TextStyle(color: Colors.white70));
  //         } else if (snapshot.connectionState == ConnectionState.waiting) {
  //           return AnimatedTextKit(
  //             animatedTexts: [
  //               ColorizeAnimatedText(
  //                 'Text is Loading',
  //                 textStyle:
  //                     const TextStyle(color: Colors.white70, fontSize: 16),
  //                 colors: [Colors.white, Colors.white54],
  //               ),
  //             ],
  //             isRepeatingAnimation: true,
  //           );
  //         }
  //         final lastMessageMap =
  //             snapshot.data!.docs.last.data() as Map<String, dynamic>;
  //         Message message = Message.fromJson(lastMessageMap);
  //         return Text(
  //           message.contents,
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //           style: const TextStyle(color: Colors.white70),
  //         );
  //       },
  //     ),
  //     onTap: () =>
  //         Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //       return ChatWithPage(
  //         chat: chat,
  //         chatName: chat.belongsToEmails.first != signedInUser?.email
  //             //! WHat if display name is same, we need to do it with email rather
  //             ? chat.chatNames.first ?? ''
  //             : chat.chatNames.last ?? '',
  //         recepientEmail: chat.belongsToEmails.first != signedInUser?.email
  //             //! WHat if display name is same, we need to do it with email rather
  //             ? chat.belongsToEmails.first ?? ''
  //             : chat.belongsToEmails.last ?? '',
  //         senderEmail: signedInUser!.email!,
  //       );
  //     })),
  //     enabled: true,
  //     enableFeedback: true,
  //   );
  // }

  Widget chatTile(ChatStore chatStore, BuildContext context) {
    return Hero(
      tag: chatStore.id ?? '_',
      child: ListTile(
        tileColor: kBackgroundColor,
        splashColor: kSexyTealColor.withOpacity(0.2),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(chatStore.photoUrl),
        ),
        title: Text(
          chatStore.name ?? '',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          chatStore.mostRecentMessage.contents ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white70),
        ),
        // trailing: Align(
        //   alignment: Alignment.centerLeft,
        //   child:
        //       _isMe(chatStore.mostRecentMessage.senderEmail, signedInUser!.email!)
        //           ? chatStore.mostRecentMessage.isSeen
        //               ? const Icon(
        //                   Icons.done_all,
        //                   color: Colors.blue,
        //                   size: 12,
        //                 )
        //               : const Icon(
        //                   Icons.done,
        //                   color: Colors.grey,
        //                   size: 17,
        //                 )
        //           : const SizedBox(),
        // ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatWithPage(chatStore: chatStore)));
        },
        enabled: true,
        enableFeedback: true,
      ),
    );
  }

  void updateListView() async {
    final Future<Database> dbFuture = chatDatabaseHelper.initializeDatabase();
    dbFuture.then((value) {
      chatDatabaseHelper.getChatsList().then((chatList) {
        setState(() {
          this.chatList = chatList;
          count = chatList.length;
        });
      });
    });
  }

  bool _isMe(String sender, String signedInUserEmail) {
    bool isMe = sender == signedInUserEmail ? true : false;
    return isMe;
  }
}
