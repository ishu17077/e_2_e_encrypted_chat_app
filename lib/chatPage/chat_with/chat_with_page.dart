import 'dart:math';
import 'dart:typed_data';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/sign_up_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/mesure_size.dart';
import 'package:e_2_e_encrypted_chat_app/databases/chat_database_helper.dart';
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
import 'package:e_2_e_encrypted_chat_app/server_functions/get_messages.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqflite.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatWithPage extends StatefulWidget {
  ChatStore chatStore;
  bool chatExists;

  ChatWithPage({
    super.key,
    this.chatExists = true,
    required this.chatStore,
  });

  @override
  State<ChatWithPage> createState() => _ChatWithPageState();
}

class _ChatWithPageState extends State<ChatWithPage> {
  late User? signedInUser;

  MessageStore? previousMessageStore;
  double heightOfTextField = 0;
  int count = 0;
  List<MessageStore> messageStoreList = List.empty(growable: true);
  final AddNewChat _addNewChat = AddNewChat();
  MessageDatabaseHelper messageDatabaseHelper = MessageDatabaseHelper();
  final GlobalKey _textBoxChangeKey = GlobalKey();
  my_user.User? user;
  // ScrollController _scrollController = ScrollController();
  // Stream<QuerySnapshot<Map<String, dynamic>>>? _mystream;
  static final ChatDatabaseHelper _chatDatabaseHelper = ChatDatabaseHelper();
  int? chatId;
  var _myStream;
  bool keepLoading = true;
  Future? _userFromFuture;
  List<int>? _encryptionKeys;
  bool initialScrollDone = false;
  // Uint8List? _iv;

  // final GlobalKey stickeyKey = GlobalKey();
  @override
  void initState() {
    chatId = widget.chatStore.id;
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
            isEqualTo: widget.chatStore
                .belongsToEmail) //? Yahan widget.chatStore.belongToEmail hoga because woh specific id match karna ha hume
        .get()
        .then((snapshot) {
      user = my_user.User.fromJson(snapshot.docs.first.data());

      // messageDatabaseHelper.insertMessage(MessageStore(
      //   recipientEmail: 'lo@mail.com',
      //   chatId: widget.chatStore.id!,
      //   contents: 'hey there',
      //   isSeen: true,
      //   senderEmail: 'chhotabheem5663@gmail.com',
      //   time: DateTime.now(),
      // ));
      // updateListView(widget.chatStore);

      getEncryptedKeys().then((value) {
        GetMessages.messageStream((docs, firestoreMessageCollection) =>
            onNewMessage(docs, firestoreMessageCollection));
      });
    });

    //! _mystream was seperately assigned as it was changing with everytime something happens like a keyboard pop up lol
    super.initState();
  }

  void onNewMessage(Map<String, dynamic> docs,
      CollectionReference<Map<String, dynamic>> firestoreMessageCollection) {
    final Message message = Message.fromJson(docs);
    decryptedMessage(
            iv: message.iv,
            encryptedMessageContents: message.contents,
            deriveKey: _encryptionKeys!)
        .then((value) {
      MessageStore messageStore = MessageStore(
          recipientEmail: message.recipientEmail,
          chatId: chatId!,
          contents: value!,
          isSeen: message.isSeen,
          senderEmail: message.senderEmail,
          time: message.time);
      messageDatabaseHelper.insertMessage(messageStore).then((value) {
        widget.chatStore.mostRecentMessage = messageStore;
        _chatDatabaseHelper.insertChat(widget.chatStore);
        firestoreMessageCollection.doc(message.id!).delete();
        updateListView(widget.chatStore);
      });
    }).onError((error, stackTrace) {
      print("Unable to decrypt message");
    });
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
              tag: chatId ?? '_',
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
              child: Stack(
                children: [
                  heightOfTextField != 0
                      ? Positioned(
                          bottom:
                              heightOfTextField == 0 ? 26 : heightOfTextField,
                          top: MediaQuery.of(context).size.height * 0.010,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              reverse: true,
                              itemBuilder: (context, index) {
                                MessageStore messageStore =
                                    messageStoreList[index];
                                bool noMarginRequired = messageStore
                                        .senderEmail ==
                                    previousMessageStore
                                        ?.senderEmail; //? for some weird reason when previousMessageStore is null it actually returns false

                                previousMessageStore = messageStore;

                                return ChatPill(
                                  text: messageStore.contents,
                                  isSeen: messageStore.isSeen,
                                  isLastMessage: index ==
                                      0, //? Listview is reverse so 0 index = last at screen
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
                        // double? screenHeight =
                        //     MediaQuery.of(context).size.height;
                        double widgetHeight = size.height;
                        if (widgetHeight <= 55) {
                          setState(() {
                            heightOfTextField = widgetHeight / 2;
                          });
                        } else if (widgetHeight > 55 && widgetHeight < 67) {
                          setState(() {
                            heightOfTextField = widgetHeight / 1.55;
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
                          await _sendMessage(contents);
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

  Future<void> _sendMessage(String unEncryptedContents) async {
    if (unEncryptedContents.isNotEmpty) {
      Message message = Message(
          recipientEmail: widget.chatStore.belongsToEmail,
          time: DateTime.now(),
          iv: _iv(),
          senderEmail: signedInUser!.email!,
          contents: unEncryptedContents,
          isSeen: false);
      if (widget.chatExists == false) {
        await _addNewChatToChatTable(message);
      }
      message.contents = await encryptMessage(
          iv: message!.iv!,
          messageContents: unEncryptedContents,
          deriveKey: _encryptionKeys!);
      int id = await _insertMessageToDatabase(message, unEncryptedContents);
      updateListView(widget.chatStore);
      _firestore
          .collection('messages')
          .add(message.toJson())
          .onError((error, stackTrace) {
        _deleteToDatabase(id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Couldn\'t send your last message, please check your internet connection',
          style: TextStyle(color: Colors.red),
        )));
        throw Exception(
            'Message can\'t be sent, check your internet connection');
      });
    }
  }

  Future<void> _addNewChatToChatTable(Message message) async {
    await _addNewChat.addNewChat(widget.chatStore).then((value) {
      widget.chatExists = true;
      chatId = value;
      return value;
    });
    print(chatId);
    widget.chatStore.mostRecentMessage = MessageStore(
      recipientEmail: message.recipientEmail,
      chatId: chatId!,
      contents: message.contents,
      isSeen: message.isSeen,
      senderEmail: message.senderEmail,
      time: message.time,
    );
    // await ChatDatabaseHelper().updateChat(widget.chatStore, chatId!);
  }

  Future<int> _insertMessageToDatabase(
      Message message, String unEncryptedContents) async {
    MessageStore messageStore = MessageStore(
        recipientEmail: message.recipientEmail,
        chatId: chatId!,
        contents: unEncryptedContents,
        isSeen: message.isSeen,
        senderEmail: message.senderEmail,
        time: message.time);

    int id = await messageDatabaseHelper.insertMessage(messageStore);
    widget.chatStore.mostRecentMessage = messageStore;
    await _chatDatabaseHelper.updateChat(widget.chatStore, chatId!);
    updateListView(widget.chatStore);
    return id;
  }

  Future<void> _deleteToDatabase(int id) async {
    await messageDatabaseHelper.deleteMessage(id);
  }

  bool _isMe(String sender, String signedInUserEmail) {
    bool isMe = sender == signedInUserEmail ? true : false;
    return isMe;
  }

  void updateListView(ChatStore chatStore) async {
    final Future<Database> dbFuture =
        messageDatabaseHelper.initializeDatabase();
    dbFuture.then((value) {
      messageDatabaseHelper
          .getMessagesList(chatStore, chatId: chatId)
          .then((messageList) {
        setState(() {
          messageStoreList = messageList;
          count = messageList.length;
        });
      });
    });
  }

  // _scrollToEnd() {
  //   _scrollController.animateTo(
  //     _scrollController.position.maxScrollExtent + 100,
  //     duration: const Duration(
  //       milliseconds: 200,
  //     ),
  //     curve: Curves.easeInOut,
  //   );
  // }

  Uint8List _iv() {
    var random = Random.secure();
    List<int> ivList = List<int>.generate(8, (_) => random.nextInt(99));
    Uint8List iv = Uint8List.fromList(ivList);
    return iv;
  }
  //! isSeen not working
}
