import 'dart:typed_data';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/sign_up_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/mesure_size.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption_methods.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart' as my_user;
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
  double heightOfTextField = 0;
  final AddNewChat _addNewChat = AddNewChat();
  final GlobalKey _textBoxChangeKey = GlobalKey();
  my_user.User? user;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _mystream;
  Future? _userFromFuture;
  List<int>? _encryptionKeys;
  Uint8List? _iv;

  // final GlobalKey stickeyKey = GlobalKey();
  @override
  void initState() {
    signedInUser = AddNewUser.signedInUser;
    if (signedInUser == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpPage()));
    }
    _iv = Uint8List.fromList(widget.chat.chatId.codeUnits);
    _userFromFuture = _firestore
        .collection('users')
        .where('email_address', isEqualTo: widget.recepientEmail)
        .get()
        .then((snapshot) {
      user = my_user.User.fromJson(snapshot.docs.first.data());
      getEncryptedKeys().then((value) {
        _mystream = _firestore
            .collection('messages')
            .where('chat_id', isEqualTo: widget.chat.chatId)
            .orderBy('time')
            .snapshots();
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
        child: FutureBuilder(
            future: _userFromFuture,
            builder: (context, futureshot) {
              if (futureshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (futureshot.hasError) {
                return const Center(
                    child: Text(
                        "There's an error processing this chat...check again later"));
              }
              return StreamBuilder<QuerySnapshot>(
                stream: _mystream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                            "There's an error processing this chat...check again later"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var docsSnapshot = snapshot.data!.docs;
                  return Stack(
                    children: [
                      heightOfTextField != 0
                          ? Positioned(
                              bottom: heightOfTextField == 0
                                  ? 26
                                  : heightOfTextField,
                              top: MediaQuery.of(context).size.height * 0.010,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  reverse: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: docsSnapshot.reversed
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> messageMap = document
                                        .data()! as Map<String, dynamic>;

                                    Message message =
                                        Message.fromJson(messageMap);

                                    message.id = document.id;
                                    if (message.senderEmail !=
                                            signedInUser!.email &&
                                        message.isSeen == false) {
                                      _firestore
                                          .collection('messages')
                                          .doc(message.id)
                                          .update({"is_seen": true});
                                    }
                                    bool noMarginRequired =
                                        message.senderEmail ==
                                            previousMessage?.senderEmail;
                                    previousMessage = message;

                                    Future<String> decryptMessageFuture = decryptedMessage(
                                                iv: _iv!,
                                                encryptedMessageContents:
                                                    message.contents,
                                                deriveKey: _encryptionKeys!)
                                            .then((value) =>
                                                message.contents = value);
                                                
                                    return FutureBuilder(
                                        future: decryptMessageFuture,
                                        builder: (context, futureshot) {
                                          if (futureshot.hasError) {
                                            return const Center(
                                                child: Text(
                                                    "There's an error processing this chat...check again later"));
                                          }
                                          if (futureshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox();
                                          }
                                          return ChatPill(
                                            text: message.contents,
                                            isLastMessage:
                                                docsSnapshot.last == document,
                                            isSeen: message.isSeen,
                                            isMe: _isMe(
                                              message.senderEmail,
                                              signedInUser!.email!,
                                            ),
                                            noMaginRequired: noMarginRequired,
                                          );
                                        });
                                  }).toList(),
                                ),
                              ),
                            )
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
                            } else if (widgetHeight >= 67 &&
                                widgetHeight < 95) {
                              setState(() {
                                heightOfTextField = widgetHeight / 1.425;
                              });
                            } else if (widgetHeight >= 100 &&
                                widgetHeight < 115) {
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
                                    recepientEmail: widget.recepientEmail,
                                    time: DateTime.now(),
                                    chatId: widget.chat.chatId,
                                    senderEmail: widget.senderEmail,
                                    contents: contents,
                                    isSeen: false);
                                if (widget.chatExists == false) {
                                  _addNewChat.addNewChat(widget.chat).then(
                                      (value) => widget.chatExists = true);
                                }
                                message.contents = await encryptMessage(
                                    iv: _iv!,
                                    messageContents: contents,
                                    deriveKey: _encryptionKeys!);
                                _firestore
                                    .collection('messages')
                                    .add(message.toJson());
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
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
}
