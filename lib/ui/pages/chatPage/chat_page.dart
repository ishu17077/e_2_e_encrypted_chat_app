// import 'dart:async';
// import 'dart:convert';

// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:secuchat/ui/pages/authentication_pages/sign_up_page.dart';
// import 'package:secuchat/ui/pages/chatPage/add_new_chat/add_new_chat_page.dart';

// import 'package:secuchat/ui/pages/chatPage/chat_with/chat_with_page.dart';
// import 'package:secuchat/databases/chat_database_helper.dart';
// import 'package:secuchat/databases/message_database_helper.dart';
// import 'package:secuchat/models/chat_store.dart';
// import 'package:secuchat/models/message_store.dart';
// import 'package:secuchat/server_functions/add_new_user.dart';
// import 'package:secuchat/server_functions/get_messages.dart';
// import 'package:secuchat/unit_components.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';

// final _firestore = FirebaseFirestore.instance;

// class ChatPage extends StatefulWidget {
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
//   int count = 0;
//   bool keepLoading = true;
//   bool shouldHideTextField = false;

//   final signedInUser = AddNewUser.signedInUser;
//   @override
//   void initState() {
//     if (signedInUser == null) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => SignUpPage()));
//     }

//     WidgetsBinding.instance.addObserver(this);

//     messageDatabaseHelper.initializeDatabase();
//     GetMessages.getEncryptedKeysForAllUsers().then((value) {
//       derivedKeyForAllEmailAddress = value;
//       _chatStream = GetMessages.messageStream(
//           updateChatView: () => updateListView(),
//           messageDatabaseHelper: messageDatabaseHelper,
//           chatDatabaseHelper: chatDatabaseHelper,
//           derivedBitsKey: value!);

//       setState(() {
//         keepLoading = false;
//       });
//       updateListView();
//     });

//     // print(json.encode(value));
//     super.initState();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         print('AppCycleState resumed');
//         _chatStream?.resume();
//         _chatStream?.resume();
//         _chatStream?.resume();
//         _chatStream?.resume();
//         _chatStream?.resume();
//         _chatStream?.resume();
//         updateListView();

//         break;
//       case AppLifecycleState.inactive:
//         print('AppCycleState inactive');

//         break;
//       case AppLifecycleState.paused:
//         print('AppCycleState paused');
//         _chatStream?.pause();
//         break;
//       case AppLifecycleState.detached:
//         print('AppCycleState detached');
//         // _chatStream?.pause();
//         break;
//       case AppLifecycleState.hidden:
//         print('AppCycleState hidden');
//         _chatStream?.pause();
//         // _chatStream?.pause();
//         break;
//     }
//   }

//   @override
//   void dispose() {
//     _chatStream?.cancel();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//     _chatStream?.resume();
//     updateListView();

//     super.didChangeDependencies();
//   }

//   // List<Message> messages = [];
//   @override
//   Widget build(BuildContext context) {
//     _chatStream?.resume();

//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: kBackgroundColor,
//       body: SafeArea(
//         child: keepLoading
//             ? const Center(child: CircularProgressIndicator())
//             : keepLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : NestedScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     // controller: _scrollController,
//                     headerSliverBuilder: (context, innerBoxIsScrolled) => [
//                       SliverAppBar(
//                         elevation: 0.0,
//                         leading: null,
//                         collapsedHeight: 60,
//                         backgroundColor: kBackgroundColor,
//                         flexibleSpace: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 10.0,
//                                     bottom: 0.0,
//                                     left: 8.0,
//                                     right: 11.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     const Text(
//                                       "Conversations",
//                                       style: TextStyle(
//                                         fontSize: 30,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     MaterialButton(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 0, horizontal: 10),
//                                       color: kSexyTealColor.withOpacity(0.8),
//                                       elevation: 5,
//                                       shape: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(20.0),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                       child: const Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.add,
//                                             color: kBackgroundColor,
//                                           ),
//                                           Text(
//                                             'Add New',
//                                             style: TextStyle(
//                                                 color: kBackgroundColor,
//                                                 fontSize: 13),
//                                           ),
//                                         ],
//                                       ),
//                                       onPressed: () {
//                                         Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => ChatAdd(
//                                                     derivedKeyForAllEmailAddress!,
//                                                     updateListView),
//                                                 maintainState: true));
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(height: MediaQuery.of(context).size.height * 0.010),
//                             // innerBoxIsScrolled
//                             //     ? Container()
//                             //     :
//                           ],
//                         ),
//                       )
//                     ],
//                     body: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               top: 5.0, bottom: 0.0, left: 8.0, right: 11.0),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.zero,
//                               fillColor: kTextFieldColor,
//                               filled: true,
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(40),
//                                   borderSide: BorderSide.none),
//                               prefixIcon: const Icon(
//                                 Icons.search_rounded,
//                                 color: Colors.teal,
//                               ),
//                             ),
//                             style: const TextStyle(
//                               color: Colors.white,
//                             ),
//                             cursorColor: Colors.teal,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Expanded(
//                           child: ListView.builder(
//                             itemBuilder: (context, index) {
//                               return chatTile(chatList![index], context);
//                             },
//                             itemCount: count,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//       ),
//     );
//   }

//   Widget chatTile(ChatStore chatStore, BuildContext context) {
//     return ListTile(
//       tileColor: kBackgroundColor,
//       splashColor: kSexyTealColor.withOpacity(0.2),
//       leading: Hero(
//         tag: chatStore.id ?? '_',
//         child: CircleAvatar(
//           backgroundImage: NetworkImage(chatStore.photoUrl ??
//               'https://www.shutterstock.com/image-photo/red-text-any-questions-paper-600nw-2312396111.jpg'),
//         ),
//       ),
//       title: Text(
//         chatStore.name ?? '',
//         style: const TextStyle(color: Colors.white),
//       ),
//       subtitle: Text(
//         chatStore.mostRecentMessage?.contents ?? '',
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: const TextStyle(color: Colors.white70),
//       ),
//       // trailing: Align(
//       //   alignment: Alignment.centerLeft,
//       //   child:
//       //       _isMe(chatStore.mostRecentMessage.senderEmail, signedInUser!.email!)
//       //           ? chatStore.mostRecentMessage.isSeen
//       //               ? const Icon(
//       //                   Icons.done_all,
//       //                   color: Colors.blue,
//       //                   size: 12,
//       //                 )
//       //               : const Icon(
//       //                   Icons.done,
//       //                   color: Colors.grey,
//       //                   size: 17,
//       //                 )
//       //           : const SizedBox(),
//       // ),
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => ChatWithPage(
//             chatStore: chatStore,
//             derivedKey: derivedKeyForAllEmailAddress!,
//             chatExists: true,
//             updateChatsView: updateListView,
//           ),
//         ));
//       },
//       enabled: true,
//       enableFeedback: true,
//     );
//   }

//   void updateListView() async {
//     final Future<Database> dbFuture = chatDatabaseHelper.initializeDatabase();
//     dbFuture.then((value) {
//       chatDatabaseHelper.getChatsList().then((chatList) {
//         setState(() {
//           this.chatList = chatList;

//           count = chatList.length;
//         });
//       });
//     });
//   }

//   bool _isMe(String sender, String signedInUserEmail) {
//     bool isMe = sender == signedInUserEmail ? true : false;
//     return isMe;
//   }
// }
