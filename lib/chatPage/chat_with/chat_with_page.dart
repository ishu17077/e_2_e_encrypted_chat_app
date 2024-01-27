import 'dart:typed_data';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/sign_up_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/mesure_size.dart';
import 'package:e_2_e_encrypted_chat_app/databases/message_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption_methods.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:e_2_e_encrypted_chat_app/models/message_store.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart' as my_user;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/chat_pill.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/chat_text_field.dart';
import 'package:e_2_e_encrypted_chat_app/models/message.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_chat.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqflite.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatWithPage extends StatefulWidget {
  ChatStore chatStore;
  bool chatExists;
  DateTime? lastOnline = DateTime.tryParse('19700101');

  ChatWithPage({
    super.key,
    this.chatExists = true,
    required this.chatStore,
    this.lastOnline,
  });

  @override
  State<ChatWithPage> createState() => _ChatWithPageState();
}

class _ChatWithPageState extends State<ChatWithPage> {
  late User? signedInUser;
  MessageStore? previousMessageStore = null;
  double heightOfTextField = 0;
  int count = 0;
  List<MessageStore> messageStoreList = List.empty(growable: true);
  final AddNewChat _addNewChat = AddNewChat();
  MessageDatabaseHelper messageDatabaseHelper = MessageDatabaseHelper();
  final GlobalKey _textBoxChangeKey = GlobalKey();
  my_user.User? user;
  ScrollController _scrollController = ScrollController();
  // Stream<QuerySnapshot<Map<String, dynamic>>>? _mystream;
  var _myStream;
  bool keepLoading = true;
  Future? _userFromFuture;
  List<int>? _encryptionKeys;
  bool initialScrollDone = false;
  // Uint8List? _iv;

  // final GlobalKey stickeyKey = GlobalKey();
  @override
  void initState() {
    signedInUser = AddNewUser.signedInUser;
    if (signedInUser == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpPage()));
    }
    updateListView(widget.chatStore);
    // _iv = Uint8List.fromList(widget.chatStore.chatId.codeUnits);
    // _scrollController.position.maxScrollExtent;
    _userFromFuture = _firestore
        .collection('users')
        .where('email_address',
            isEqualTo:
                'chhotabheem5663@gmail.com') //? Yahan widget.chatStore.belongToEmail hoga because woh specific id match karna ha hume
        .get()
        .then((snapshot) {
      user = my_user.User.fromJson(snapshot.docs.first.data());

      // messageDatabaseHelper.insertMessage(MessageStore(
      //   recepientEmail: 'lo@mail.com',
      //   chatId: widget.chatStore.id!,
      //   contents: 'hey there',
      //   isSeen: true,
      //   senderEmail: 'chhotabheem5663@gmail.com',
      //   time: DateTime.now(),
      // ));
      // updateListView(widget.chatStore);

      getEncryptedKeys();
    });
    _myStream = _firestore
        .collection('messages')
        .where('recipient_email',
            isEqualTo: 'chhotabheem5663@gmail.com') //? Yahan bhi
        .orderBy('time', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> docs =
            documentSnapshot.data()! as Map<String, dynamic>;
        final Message message = Message.fromJson(docs);
        print(message.contents);
        return 1;
      });
    });
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

  Future getEncryptedKeys() async {
    final privateKey = await EncryptionMethods.getPrivateKeyJwk();

    _encryptionKeys =
        await EncryptionMethods.getDerivedKey(privateKey!, user!.publicKeyJwb!);
    setState(() {
      keepLoading = false;
    });

    return null;
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(),
                ));
          },
        ),
        backgroundColor: kBackgroundColor,
        // elevation: 10,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ignore: prefer_const_constructors
            Hero(
              tag: widget.chatStore.id ?? '_',
              child: CircleAvatar(
                backgroundColor: kSexyTealColor,
                backgroundImage: NetworkImage(widget.chatStore.photoUrl),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Text(
              widget.chatStore.name ??
                  '', //? Jab change karne ka option hoga username tab server se refresh karenge
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: keepLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 7.0),
              child:
                  // FutureBuilder(
                  // future: _userFromFuture,
                  // builder: (context, futureshot) {
                  //   if (futureshot.connectionState == ConnectionState.waiting) {
                  //     return const Center(child: CircularProgressIndicator());
                  //   }
                  //   if (futureshot.hasError) {
                  //     return const Center(
                  //         child: Text(
                  //             "There's an error processing this chat...check again later"));
                  //   }
                  //   return

                  Stack(
                children: [
                  heightOfTextField != 0
                      ?
                      // StreamBuilder<QuerySnapshot>(
                      //     stream: _mystream,
                      //     builder: (BuildContext context,
                      //         AsyncSnapshot<QuerySnapshot> snapshot) {
                      //       // if (snapshot.hasError) {
                      //       //   return const Center(
                      //       //       child: Text(
                      //       //           "There's an error processing this chat...check again later"));
                      //       // }
                      //       // if (snapshot.connectionState == ConnectionState.waiting) {
                      //       //   return const Center(child: CircularProgressIndicator());
                      //       // }
                      //       var docsSnapshot = snapshot.data!.docs;
                      //       return
                      Positioned(
                          bottom:
                              heightOfTextField == 0 ? 26 : heightOfTextField,
                          top: MediaQuery.of(context).size.height * 0.010,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            // child: ListView(
                            //   reverse: true,
                            //   physics: const BouncingScrollPhysics(),
                            //   children: docsSnapshot.reversed
                            //       .map((DocumentSnapshot document) {

                            //     Map<String, dynamic> messageMap =
                            //         document.data()! as Map<String, dynamic>;

                            //     Message message = Message.fromJson(messageMap);

                            //     message.id = document.id;
                            //     if (message.senderEmail != signedInUser!.email &&
                            //         message.isSeen == false) {
                            //       _firestore
                            //           .collection('messages')
                            //           .doc(message.id)
                            //           .update({"is_seen": true});
                            //     }
                            //     bool noMarginRequired = message.senderEmail ==
                            //         previousMessage?.senderEmail;
                            //     previousMessage = message;

                            //     Future<String> decryptMessageFuture =
                            //         decryptedMessage(
                            //                 iv: message!.iv!,
                            //                 encryptedMessageContents:
                            //                     message.contents,
                            //                 deriveKey: _encryptionKeys!)
                            //             .then(
                            //                 (value) => message.contents = value);

                            //     return FutureBuilder(
                            //         future: decryptMessageFuture,
                            //         builder: (context, futureshot) {
                            //           if (futureshot.hasError) {
                            //             return const Center(
                            //                 child: Text(
                            //                     "There's an error processing this message...check again later"));
                            //           }
                            //           if (futureshot.connectionState ==
                            //               ConnectionState.waiting) {
                            //             return const SizedBox();
                            //           }
                            //           messageDatabaseHelper.insertMessage(
                            //               MessageStore(
                            //                   recepientEmail:
                            //                       message.recepientEmail,
                            //                   chatId: widget.chatStore.id!,
                            //                   contents: message.contents,
                            //                   isSeen: message.isSeen,
                            //                   senderEmail: message.senderEmail,
                            //                   time: message.time));
                            //           return ChatPill(
                            //             text: message.contents,
                            //             isLastMessage:
                            //                 docsSnapshot.last == document,
                            //             isSeen: message.isSeen,
                            //             isMe: _isMe(
                            //               message.senderEmail,
                            //               signedInUser!.email!,
                            //             ),
                            //             noMaginRequired: noMarginRequired,
                            //           );
                            //         });
                            //   }).toList(),
                            // ),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                MessageStore messageStore =
                                    messageStoreList[index];
                                bool noMarginRequired = messageStore
                                        .senderEmail ==
                                    previousMessageStore
                                        ?.senderEmail; //? for some weird reason when previousMessageStore is null it actually returns false

                                previousMessageStore = messageStore;
                                if (initialScrollDone == false) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (_) => _scrollToEnd());
                                  initialScrollDone = true;
                                } //! Error
                                return ChatPill(
                                  text: messageStore.contents,
                                  isSeen: messageStore.isSeen,
                                  isLastMessage: index == count - 1,
                                  isMe: _isMe(messageStore!.senderEmail!,
                                      signedInUser!.email!),
                                  noMaginRequired: noMarginRequired,
                                );
                              },
                              itemCount: count,
                            ),
                          ),
                        )
                      // })
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: MeasureSize(
                      onChange: (size) {
                        double? screenHeight =
                            MediaQuery.of(context).size.height;
                        print("Scrren Height: $screenHeight");
                        double widgetHeight = size.height;
                        if (widgetHeight <= 55) {
                          setState(() {
                            heightOfTextField = widgetHeight / 2;
                          });
                        } else if (widgetHeight > 55 && widgetHeight < 67) {
                          setState(() {
                            heightOfTextField = widgetHeight / 1.65;
                          });
                        } else if (widgetHeight >= 67 && widgetHeight < 95) {
                          setState(() {
                            heightOfTextField = widgetHeight / 1.425;
                          });
                        } else if (widgetHeight >= 100 && widgetHeight < 115) {
                          setState(() {
                            heightOfTextField = widgetHeight / 1.30;
                          });
                        } else {
                          setState(() {
                            heightOfTextField = widgetHeight / 1.25;
                          });
                        }

                        print(size.height);
                      },
                      child: ChatTextField(
                        key: _textBoxChangeKey,
                        onSendButtonPressed: (String contents) async {
                          if (contents.isNotEmpty) {
                            Message message = Message(
                                recepientEmail: widget.chatStore.belongsToEmail,
                                time: DateTime.now(),
                                iv: Uint8List(16),
                                senderEmail: signedInUser!.email!,
                                contents: contents,
                                isSeen: false);
                            if (widget.chatExists == false) {
                              _addNewChat
                                  .addNewChat(widget.chatStore)
                                  .then((value) => widget.chatExists = true);
                            }
                            message.contents = await encryptMessage(
                                iv: message!.iv!,
                                messageContents: contents,
                                deriveKey: _encryptionKeys!);
                            _firestore
                                .collection('messages')
                                .add(message.toJson())
                                .whenComplete(() {
                              messageDatabaseHelper.insertMessage(MessageStore(
                                  recepientEmail: message.recepientEmail,
                                  chatId: widget.chatStore.id!,
                                  contents: contents,
                                  isSeen: message.isSeen,
                                  senderEmail: message.senderEmail,
                                  time: message.time));
                              updateListView(widget.chatStore);
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => _scrollToEnd());
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // }),
            ),
    );
  }

  // bool gotNotification(SizeChangedLayoutNotification notification) {
  //   // change height here
  //   var height = _textBoxChangeKey.currentContext?.size?.height;
  //   if (_heightOfTextFieldNotifier != height && height != null) {
  //     print(_heightOfTextFieldNotifier);
  //     setState(() {
  //       _heightOfTextFieldNotifier = height;
  //     });
  //   }
  //   print("Size: $height");

  //   _textBoxChangeKey = GlobalKey();
  //   return true;
  // }

  bool _isMe(String sender, String signedInUserEmail) {
    bool isMe = sender == signedInUserEmail ? true : false;
    return isMe;
  }

  void updateListView(ChatStore chatStore) async {
    final Future<Database> dbFuture =
        messageDatabaseHelper.initializeDatabase();
    dbFuture.then((value) {
      messageDatabaseHelper.getMessagesList(chatStore).then((messageList) {
        setState(() {
          messageStoreList = messageList;
          count = messageList.length;
        });
      });
    });
  }

  _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeInOut,
    );
  }
}
