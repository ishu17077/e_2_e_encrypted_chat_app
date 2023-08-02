import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/add_new_chat/add_new_chat_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/chat_with_page.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_chat.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final ScrollController _scrollController = ScrollController();
  bool shouldHideTextField = false;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _snapshotChats;
  @override
  void initState() {
    _snapshotChats = _firestore
        .collection("chats")
        .where('belongs_to_emails',
            //! Hope you see the problem
            arrayContains:
                AddNewUser.signedInUser?.email ?? 'randomleloemail@gmail.com')
        // .orderBy('time', descending: true)
        .snapshots();
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
              collapsedHeight: 70,
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
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatAdd())),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.020),
                  // innerBoxIsScrolled
                  //     ? Container()
                  //     :
                ],
              ),
            )
          ],
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 10.0, left: 8.0, right: 11.0),
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
              StreamBuilder<QuerySnapshot>(
                stream: _snapshotChats,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something Went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  // ignore: avoid_print
                  print(
                      "Signed in as email${FirebaseAuth.instance.currentUser?.email ?? 'randomleloemail@gmail.com'} ");
                  //! Hope you see the problem
                  return Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        Chat chat = Chat.fromJson(data);
                        print("Chat id: ${chat.chatId}");
                        return chatTile(chat, context);
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile chatTile(Chat chat, BuildContext context) {
    return ListTile(
                        tileColor: kBackgroundColor,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(chat.photoUrl.isEmpty
                              ? 'https://marmelab.com/images/blog/ascii-art-converter/homer.png'
                              : chat.photoUrl),
                        ),
                        title: Text(
                          chat.chatName ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          chat.lastMessage ?? '**No Text**',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatWithPage(
                                      chatName: chat.chatName,
                                      chatId: chat.chatId ?? 'No Chat Id',
                                      recepientEmail: chat.chatWithEmail,
                                      senderEmail:
                                          AddNewUser.signedInUser?.email ??
                                              'randomleloemail@gmail.com',
                                    ))),
                        enabled: true,
                        enableFeedback: true,
                      );
  }
}
