import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/sign_up_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/components/mesure_size.dart';
import 'package:e_2_e_encrypted_chat_app/databases/chat_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/databases/message_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
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
import 'package:sqflite/sqflite.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ChatWithPage extends StatefulWidget {
  static final GlobalKey<_ChatWithPageState> globalKey = GlobalKey();

  ChatStore chatStore;
  bool chatExists;
  Map<String, List<int>> derivedKey;

  Function updateChatsView;

  ChatWithPage({
    this.chatExists = true,
    required this.chatStore,
    required this.derivedKey,
    required this.updateChatsView,
  }) : super(key: globalKey);

  @override
  State<ChatWithPage> createState() => _ChatWithPageState();
}

class _ChatWithPageState extends State<ChatWithPage>
    with WidgetsBindingObserver {
  late User? signedInUser;
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
  StreamSubscription? _messageStream;
  bool initialScrollDone = false;
  // Uint8List? _iv;

  // final GlobalKey stickeyKey = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    chatId = widget.chatStore.id;
    signedInUser = AddNewUser.signedInUser;
    if (signedInUser == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpPage()));
    }
    updateListView(widget.chatStore);
    // _iv = Uint8List.fromList(widget.chatStore.chatId.codeUnits);
    // _scrollController.position.maxScrollExtent;

    // _messageStream = GetMessages.messageStream(
    //     updateMessagesListView: () => updateListView(widget.chatStore),
    //     updateChatsListView: () {},
    //     messageDatabaseHelper: messageDatabaseHelper,
    //     chatDatabaseHelper: _chatDatabaseHelper,
    //     derivedBitsKey: widget.derivedKey);
    //! _mystream was seperately assigned as it was changing with everytime something happens like a keyboard pop up lol
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // sticky?.remove();
    // stickeyKey.currentState?.dispose();
    _messageStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        widget.updateChatsView();
        Navigator.pop(context);
      },
      child: Scaffold(
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
                widget.updateChatsView();
                Navigator.pop(context);
              }),
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
                  backgroundImage: NetworkImage(widget.chatStore.photoUrl ??
                      'https://www.shutterstock.com/image-photo/red-text-any-questions-paper-600nw-2312396111.jpg'),
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
        body: Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 7.0),
          child: Stack(
            children: [
              heightOfTextField != 0
                  ? Positioned(
                      bottom: heightOfTextField == 0 ? 26 : heightOfTextField,
                      top: MediaQuery.of(context).size.height * 0.010,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          reverse: true,
                          itemBuilder: (context, index) {
                            MessageStore messageStore = messageStoreList[index];
                            // bool noMarginRequired = messageStore.senderEmail ==
                            //     (previousMessageStore?.senderEmail ??
                            //         ''); //? for some weird reason when previousMessageStore is null it actually returns false

                            return ChatPill(
                              text: messageStore.contents,
                              isSeen: messageStore.isSeen,
                              isLastMessage: index ==
                                  0, //? Listview is reverse so 0 index = last at screen
                              isMe: _isMe(messageStore!.senderEmail!,
                                  signedInUser!.email!),
                              noMaginRequired: true,
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
        List<ChatStore> chatStoreLists =
            await _chatDatabaseHelper.getChatsList();
        for (ChatStore chatStore in chatStoreLists) {
          if (chatStore.belongsToEmail == widget.chatStore.belongsToEmail) {
            widget.chatExists = true;
            chatId = chatStore.id;
            break;
          }
        }
        if (widget.chatExists == false) {
          chatId = await _addNewChatToChatTable(); //? Chat id gets updated here
        }
      }
      MessageStore messageStore = MessageStore(
        recipientEmail: message.recipientEmail,
        chatId: chatId!,
        contents: message.contents,
        isSeen: message.isSeen,
        senderEmail: message.senderEmail,
        time: message.time,
      );
      if (chatId != null) {
        _chatDatabaseHelper.updateChatMessages(messageStore, chatId!);
      }
      message.contents = await encryptMessage(
          iv: message!.iv!,
          messageContents: unEncryptedContents,
          deriveKey: widget.derivedKey[message.recipientEmail]!);
      int id = await _insertMessageToDatabase(message, unEncryptedContents);

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

  Future<int?> _addNewChatToChatTable() async {
    int? chatIdNew;
    await _addNewChat.addNewChat(widget.chatStore).then((value) {
      widget.chatExists = true;
      chatIdNew = value;
      chatId = value;
      print(widget.chatStore.toJson());
    }).whenComplete(() {
      widget.chatExists = true;
    });
    print(chatId);
    return chatIdNew;
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

  Uint8List _iv() {
    var random = Random.secure();
    List<int> ivList = List<int>.generate(8, (_) => random.nextInt(99));
    Uint8List iv = Uint8List.fromList(ivList);
    return iv;
  }
  //! isSeen not working
}
