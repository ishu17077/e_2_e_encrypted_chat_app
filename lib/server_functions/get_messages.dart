import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/chat_with_page.dart';
import 'package:e_2_e_encrypted_chat_app/databases/chat_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/databases/message_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption_methods.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:e_2_e_encrypted_chat_app/models/message_store.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:e_2_e_encrypted_chat_app/models/message.dart';
import 'package:e_2_e_encrypted_chat_app/saving_data/saving_and_retrieving_non_trivial_data.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_chat.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMessages {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

  static Future<Map<String, List<int>>> getEncryptedKeysForAllUsers() async {
    final String privateKey = (await EncryptionMethods.getPrivateKeyJwk())!;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var docs = (await firestore
            .collection('users')
            .where('email_address',
                isNotEqualTo: AddNewUser.signedInUser!.email!)
            .get())
        .docs;
    Map<String, List<int>> userEmailsAndTheirDerviedKeyWithUs = {};

    for (DocumentSnapshot element in docs) {
      Map<String, dynamic> userMap = element.data()! as Map<String, dynamic>;
      // print(userMap['public_key_jwb']);
      final User user = User.fromJson(userMap);
      SavingAndRetrievingNonTrivialData.savePublicKeyForUserEmail(prefs,
          email_address: user.emailAddress, publicKey: user.publicKeyJwb!);
      final List<int> deriveKeyForEmail =
          await deriveKey(privateKey!, user.publicKeyJwb!);
      userEmailsAndTheirDerviedKeyWithUs
          .addAll(<String, List<int>>{user!.emailAddress: deriveKeyForEmail});
    }

    return userEmailsAndTheirDerviedKeyWithUs;
  }

  static StreamSubscription messageStream(
      //? MY SECOND LOVELY PIECE of sh*t inefficient code
      {required MessageDatabaseHelper messageDatabaseHelper,
      required VoidCallback updateChatView,
      required ChatDatabaseHelper chatDatabaseHelper,
      // required SharedPreferences prefs,
      required Map<String, List<int>> derivedBitsKey}) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var firestoreMessageCollection = _firestore.collection('messages');
    bool doesChatExist = false;
    return firestoreMessageCollection
        .where('recipient_email', isEqualTo: AddNewUser.signedInUser!.email!)
        .orderBy('time', descending: true)
        .snapshots()
        .listen((querySnapshot) {
      List<DocumentChange> docChanges = querySnapshot.docChanges;
      for (DocumentChange documentChange in docChanges) {
        if (documentChange.type == DocumentChangeType.added) {
          Map<String, dynamic> docs =
              documentChange.doc.data()! as Map<String, dynamic>;
          final Message message = Message.fromJson(docs);
          print(message.senderEmail);
          message.id = documentChange.doc.id;
          decryptedMessage(
                  iv: message.iv,
                  encryptedMessageContents: message.contents,
                  deriveKey: derivedBitsKey[message.senderEmail!]!)
              .then((decryptedMessageContent) {
            chatDatabaseHelper.getChatsList().then((value) {
              int? chatId;
              for (var element in value) {
                if (element.belongsToEmail == message.senderEmail) {
                  doesChatExist = true;
                  chatId = element.id;
                  break;
                }
              }
              ChatStore chatStore = ChatStore(
                  //! name parameter missing
                  belongsToEmail: message.senderEmail,
                  photoUrl:
                      'https://www.shutterstock.com/image-photo/red-text-any-questions-paper-600nw-2312396111.jpg',
                  mostRecentMessage: null);
              if (!doesChatExist) {
                chatDatabaseHelper.getChatsList().then((value) {
                  for (var element in value) {
                    if (element.belongsToEmail == message.senderEmail) {
                      doesChatExist = true;
                      chatId = element.id;
                      break;
                    }
                  }
                });
                if (!doesChatExist) {
                  _firestore
                      .collection('users')
                      .where('email_address', isEqualTo: message.senderEmail)
                      .get()
                      .then((value) {
                    final User newUserFromWhomWeGotMessage = User.fromJson(
                        value.docs.first.data()! as Map<String, dynamic>);
                    chatStore.name = newUserFromWhomWeGotMessage.username!;
                    chatStore.photoUrl = newUserFromWhomWeGotMessage.photoUrl!;
                    chatDatabaseHelper.insertChat(chatStore).then((thisChatId) {
                      MessageStore messageStore = MessageStore(
                          recipientEmail: message.recipientEmail,
                          chatId: thisChatId,
                          contents: decryptedMessageContent ?? '',
                          isSeen: message.isSeen,
                          senderEmail: message.senderEmail,
                          time: message.time);
                      messageDatabaseHelper
                          .insertMessage(messageStore)
                          .then((value) {
                        // chatStore.mostRecentMessage = messageStore;
                        chatDatabaseHelper
                            .updateChatMessages(messageStore, thisChatId)
                            .then((value) {
                          firestoreMessageCollection
                              .doc(message.id!)
                              .delete()
                              .ignore();
                          ChatWithPage.globalKey.currentState?.mounted == true
                              ? ChatWithPage.globalKey.currentState
                                  ?.updateListView(ChatWithPage
                                      .globalKey.currentState!.widget.chatStore)
                              : () {};

                          updateChatView();
                        });
                      });
                    });
                  });
                } else {
                  //? Double chatExists checks because an instance occured where my chat was registered twice
                  MessageStore messageStore = MessageStore(
                      recipientEmail: message.recipientEmail,
                      chatId: chatId!,
                      contents: decryptedMessageContent ?? '',
                      isSeen: message.isSeen,
                      senderEmail: message.senderEmail,
                      time: message.time);

                  messageDatabaseHelper
                      .insertMessage(messageStore)
                      .then((value) async {
                    // chatStore.mostRecentMessage = messageStore;
                    chatDatabaseHelper
                        .updateChatMessages(messageStore, chatId!)
                        .then((_) {
                      firestoreMessageCollection
                          .doc(message.id!)
                          .delete()
                          .ignore();
                      ChatWithPage.globalKey.currentState?.mounted == true
                          ? ChatWithPage.globalKey.currentState?.updateListView(
                              ChatWithPage
                                  .globalKey.currentState!.widget.chatStore)
                          : () {};

                      updateChatView();
                    });
                  });
                }
              } else {
                MessageStore messageStore = MessageStore(
                    recipientEmail: message.recipientEmail,
                    chatId: chatId!,
                    contents: decryptedMessageContent ?? '',
                    isSeen: message.isSeen,
                    senderEmail: message.senderEmail,
                    time: message.time);

                messageDatabaseHelper
                    .insertMessage(messageStore)
                    .then((value) async {
                  // chatStore.mostRecentMessage = messageStore;
                  firestoreMessageCollection.doc(message.id!).delete().ignore();
                  chatDatabaseHelper
                      .updateChatMessages(messageStore, chatId!)
                      .then((_) {
                    
                    ChatWithPage.globalKey.currentState?.mounted == true
                        ? ChatWithPage.globalKey.currentState?.updateListView(
                            ChatWithPage
                                .globalKey.currentState!.widget.chatStore)
                        : () {};
                    updateChatView();
                  });
                });
              }
            });
          });
        }
      }
    });
  }

  Future sendMessage(Message message) async {
    await _db
        .collection("messages")
        .add(message.toJson())
        .then((DocumentReference doc) {
      debugPrint('DocumentSnapshot added  with ID: ${doc.id}, ${doc.path}');
      return _db.collection("messages").get();
    });
  }

  Future<bool> setData(String key, String value) async {
    await _prefs.then((prefs) {
      prefs.setString(key, value).whenComplete(() => true);
    });
    return false;
  }

  Future<String?> getData(String key) async {
    await _prefs.then((prefs) {
      return (prefs.getString(key));
    });
    return null;
  }
}
