import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/chat_with_page.dart';
import 'package:e_2_e_encrypted_chat_app/databases/chat_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/databases/message_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption_methods.dart';
import 'package:e_2_e_encrypted_chat_app/main.dart';
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

  // static StreamSubscription messageStreamUnoptimized(
  //     //? MY SECOND LOVELY PIECE of sh*t inefficient code
  //     {required MessageDatabaseHelper messageDatabaseHelper,
  //     required VoidCallback updateChatView,
  //     required ChatDatabaseHelper chatDatabaseHelper,
  //     required Map<String, List<int>> derivedBitsKey}) {
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   CollectionReference firestoreMessageCollection =
  //       _firestore.collection('messages');

  //   return firestoreMessageCollection
  //       .where('recipient_email', isEqualTo: AddNewUser.signedInUser!.email!)
  //       .orderBy('time', descending: true)
  //       .snapshots()
  //       .listen((querySnapshot) async {
  //     List<DocumentChange> docChanges = querySnapshot.docChanges;

  //     for (DocumentChange documentChange in docChanges) {
  //       bool doesChatExist = true;
  //       int? chatId;
  //       //? async await issues pop up a lot, we need to await for every result for make this happen
  //       if (documentChange.type == DocumentChangeType.added) {
  //         Map<String, dynamic> docs =
  //             documentChange.doc.data()! as Map<String, dynamic>;
  //         final Message message = Message.fromJson(docs);
  //         print(message.senderEmail);
  //         message.id = documentChange.doc.id;
  //         await decryptedMessage(
  //                 iv: message.iv,
  //                 encryptedMessageContents: message.contents,
  //                 deriveKey: derivedBitsKey[message.senderEmail!]!)
  //             .then((decryptedMessageContent) async {
  //           await chatDatabaseHelper.getChatsList().then((value) async {
  //             for (var element in value) {
  //               if (element.belongsToEmail == message.senderEmail) {
  //                 chatId = element.id;
  //               }
  //             }
  //             if (chatId == null) {
  //               doesChatExist = false;
  //             }
  //             ChatStore chatStore = ChatStore(
  //                 userIdFromServer: 'dskdjskd',
  //                 //! name parameter missing
  //                 belongsToEmail: message.senderEmail,
  //                 photoUrl:
  //                     'https://www.shutterstock.com/image-photo/red-text-any-questions-paper-600nw-2312396111.jpg',
  //                 mostRecentMessage: null);

  //             if (!doesChatExist) {
  //               await _firestore
  //                   .collection('users')
  //                   .where('email_address', isEqualTo: message.senderEmail)
  //                   .get()
  //                   .then((value) async {
  //                 final User newUserFromWhomWeGotMessage = User.fromJson(
  //                     value.docs.first.data()! as Map<String, dynamic>);
  //                 chatStore.name = newUserFromWhomWeGotMessage.username!;
  //                 chatStore.userIdFromServer = newUserFromWhomWeGotMessage.id!;
  //                 chatStore.photoUrl = newUserFromWhomWeGotMessage.photoUrl!;
  //                 await chatDatabaseHelper
  //                     .insertChat(chatStore)
  //                     .then((thisChatId) async {
  //                   chatId = thisChatId;
  //                   MessageStore messageStore = MessageStore(
  //                       recipientEmail: message.recipientEmail,
  //                       chatId: thisChatId,
  //                       contents: decryptedMessageContent ?? '',
  //                       isSeen: message.isSeen,
  //                       senderEmail: message.senderEmail,
  //                       time: message.time);
  //                   await messageDatabaseHelper
  //                       .insertMessage(messageStore)
  //                       .then((value) async {
  //                     // chatStore.mostRecentMessage = messageStore;
  //                     await chatDatabaseHelper
  //                         .updateChatMostRecentMessage(messageStore, thisChatId)
  //                         .then((value) {
  //                       doesChatExist = true;
  //                       firestoreMessageCollection
  //                           .doc(message.id!)
  //                           .delete()
  //                           .ignore();
  //                       ChatWithPage.globalKey.currentState?.mounted == true
  //                           ? ChatWithPage.globalKey.currentState
  //                               ?.updateListView(ChatWithPage
  //                                   .globalKey.currentState!.widget.chatStore)
  //                           : () {};

  //                       updateChatView();
  //                     });
  //                   });
  //                 });
  //               }).onError((error, stackTrace) {
  //                 doesChatExist = false;
  //               });
  //             } else {
  //               //? Double chatExists checks because an instance occured where my chat was registered twice
  //               //! Because on improper await of statements
  //               //* First chat can be slow and it will stay speedy the other times.
  //               MessageStore messageStore = MessageStore(
  //                   recipientEmail: message.recipientEmail,
  //                   chatId: chatId!,
  //                   contents: decryptedMessageContent ?? '',
  //                   isSeen: message.isSeen,
  //                   senderEmail: message.senderEmail,
  //                   time: message.time);

  //               await messageDatabaseHelper
  //                   .insertMessage(messageStore)
  //                   .then((value) async {
  //                 // chatStore.mostRecentMessage = messageStore;
  //                 await chatDatabaseHelper
  //                     .updateChatMostRecentMessage(messageStore, chatId!)
  //                     .then((_) {
  //                   firestoreMessageCollection
  //                       .doc(message.id!)
  //                       .delete()
  //                       .ignore();
  //                   ChatWithPage.globalKey.currentState?.mounted == true
  //                       ? ChatWithPage.globalKey.currentState?.updateListView(
  //                           ChatWithPage
  //                               .globalKey.currentState!.widget.chatStore)
  //                       : () {};

  //                   updateChatView();
  //                 });
  //               });
  //             }
  //           });
  //         });
  //       }
  //     }
  //   });
  // }

  static StreamSubscription messageStream(
      {required MessageDatabaseHelper messageDatabaseHelper,
      required VoidCallback updateChatView,
      required ChatDatabaseHelper chatDatabaseHelper,
      required Map<String, List<int>> derivedBitsKey}) {
    //? Apparently more effecient code
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    CollectionReference firestoreMessageCollection =
        _firestore.collection('messages');

    return firestoreMessageCollection
        .where('recipient_email', isEqualTo: AddNewUser.signedInUser!.email!)
        .orderBy('time', descending: true)
        .snapshots()
        .listen((querySnapshot) async {
      List<DocumentChange> docChanges = querySnapshot.docChanges;
      for (DocumentChange documentChange in docChanges) {
        if (documentChange.type == DocumentChangeType.added) {
          bool doesChatExist = false;
          int? chatId;
          var messageMap = documentChange.doc.data()! as Map<String, dynamic>;
          final Message message = Message.fromJson(messageMap);
          message.id = documentChange.doc.id;
          message.contents = await decryptedMessage(
              iv: message.iv,
              encryptedMessageContents: message.contents,
              deriveKey: derivedBitsKey[message.senderEmail]!);
          await chatDatabaseHelper
              .getChatsList()
              .then((List<ChatStore> chatList) async {
            for (ChatStore chat in chatList) {
              if (message.senderEmail == chat.belongsToEmail) {
                doesChatExist = true;
                chatId = chat.id;
                break;
              }
            }
            if (!doesChatExist && chatId == null) {
              await _firestore
                  .collection('users')
                  .where('email_address', isEqualTo: message.senderEmail)
                  .get()
                  .then((querySnapshot) async {
                var firstUserWithRightHit = querySnapshot.docs.first;
                Map<String, dynamic> newUserMap = firstUserWithRightHit.data();
                User newUser = User.fromJson(newUserMap);
                ChatStore chatStoreNewUser = ChatStore.withUserServerIdSetter(
                    name: newUser.username,
                    belongsToEmail: newUser.emailAddress,
                    photoUrl: newUser.photoUrl,
                    mostRecentMessage: null,
                    userIdFromServer: firstUserWithRightHit.id);
                await chatDatabaseHelper
                    .insertChat(chatStoreNewUser)
                    .then((chatIdNew) async {
                  chatId = chatIdNew;
                  MessageStore newMessageStore =
                      MessageStore.withMessageServerId(
                          recipientEmail: message.recipientEmail,
                          messageIdFromServer: message.id!,
                          chatId: chatId!,
                          contents: message.contents,
                          isSeen: message.isSeen,
                          senderEmail: message.senderEmail,
                          time: message.time);
                  messageDatabaseHelper
                      .insertMessage(newMessageStore)
                      .then((_) {
                    chatStoreNewUser.mostRecentMessage = newMessageStore;
                    doesChatExist = true;

                    ChatWithPage.globalKey.currentState?.mounted == true
                        ? ChatWithPage.globalKey.currentState?.updateListView(
                            ChatWithPage
                                .globalKey.currentState!.widget.chatStore)
                        : () {};
                    updateChatView();
                    chatDatabaseHelper
                        .updateChat(chatStoreNewUser, chatIdNew)
                        .then((_) {
                      updateChatView();
                      firestoreMessageCollection
                          .doc(message.id!)
                          .delete()
                          .ignore();
                    });
                  });
                });
              });
            } else {
              MessageStore newMessage = MessageStore.withMessageServerId(
                  recipientEmail: message.recipientEmail,
                  chatId: chatId!,
                  messageIdFromServer: message.id!,
                  contents: message.contents,
                  isSeen: message.isSeen,
                  senderEmail: message.senderEmail,
                  time: message.time);

              await messageDatabaseHelper
                  .insertMessage(newMessage)
                  .then((value) {
                ChatWithPage.globalKey.currentState?.mounted == true
                    ? ChatWithPage.globalKey.currentState?.updateListView(
                        ChatWithPage.globalKey.currentState!.widget.chatStore)
                    : () {};
                chatDatabaseHelper
                    .updateChatMostRecentMessage(newMessage, chatId!)
                    .then((_) {
                  updateChatView();
                  firestoreMessageCollection.doc(message.id!).delete().ignore();
                });
              });
            }
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
