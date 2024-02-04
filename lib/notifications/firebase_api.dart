import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/databases/chat_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/databases/message_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption_methods.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:e_2_e_encrypted_chat_app/models/message.dart' as serverMessage;
import 'package:e_2_e_encrypted_chat_app/models/message_store.dart';
import 'package:e_2_e_encrypted_chat_app/models/user.dart';
import 'package:e_2_e_encrypted_chat_app/notifications/local_notification_service.dart';
import 'package:e_2_e_encrypted_chat_app/public_key_store_methods/public_key_store_and_retrieve.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final MessageDatabaseHelper _messageDatabaseHelper = MessageDatabaseHelper();
final ChatDatabaseHelper _chatDatabaseHelper = ChatDatabaseHelper();
final LocalNotificationService _localNotificationService =
    LocalNotificationService();
Future<String?> futurePrivateKeyJwk = EncryptionMethods.getPrivateKeyJwk();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final String privateKeyJwk = (await futurePrivateKeyJwk)!;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final QuerySnapshot value = (await _firestore
      .collection('messages')
      .where('recipient_email', isEqualTo: AddNewUser.signedInUser!.email!)
      .get());

  for (DocumentChange change in value.docChanges) {
    if (change.type == DocumentChangeType.added) {
      var data = change.doc.data()!;
      final serverMessage.Message message =
          serverMessage.Message.fromJson(data as Map<String, dynamic>);
      print(message.senderEmail);
      String publicKeyJwk =
          await PublicKeyStoreAndRetrieve.retrievePublicKeyForUserEmail(prefs,
                  email_address: message.senderEmail) ??
              (await _firestore
                  .collection('users')
                  .where('email_address', isEqualTo: message.recipientEmail)
                  .get()
                  .then((snapshot) {
                User user = User.fromJson(snapshot.docs.first.data());
                return user.publicKeyJwb!;
              }));
      message.id = change.doc.id;

      decryptedMessage(
        iv: message.iv,
        encryptedMessageContents: message.contents,
        deriveKey: await deriveKey(privateKeyJwk, publicKeyJwk),
      ).then((decryptedMessageContent) {
        _chatDatabaseHelper.getChatsList().then((value) {
          bool doesChatExist = false;
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
            _chatDatabaseHelper.getChatsList().then((value) {
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
                _chatDatabaseHelper.insertChat(chatStore).then((thisChatId) {
                  MessageStore messageStore = MessageStore(
                      recipientEmail: message.recipientEmail,
                      chatId: thisChatId,
                      contents: decryptedMessageContent ?? '',
                      isSeen: message.isSeen,
                      senderEmail: message.senderEmail,
                      time: message.time);
                  _messageDatabaseHelper
                      .insertMessage(messageStore)
                      .then((value) {
                    // chatStore.mostRecentMessage = messageStore;
                    _chatDatabaseHelper
                        .updateChatMessages(messageStore, thisChatId)
                        .then((value) {
                      _localNotificationService.showNotification(
                          title: chatStore.name! ?? 'Anonymous',
                          body: decryptedMessageContent);
                      _firestore
                          .collection('messages')
                          .doc(message.id!)
                          .delete()
                          .ignore();
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

              _messageDatabaseHelper
                  .insertMessage(messageStore)
                  .then((value) async {
                // chatStore.mostRecentMessage = messageStore;
                _chatDatabaseHelper
                    .updateChatMessages(messageStore, chatId!)
                    .then((_) {
                  _localNotificationService.showNotification(
                      title: chatStore.name! ?? 'Anonymous',
                      body: decryptedMessageContent);
                  _firestore
                      .collection('messages')
                      .doc(message.id!)
                      .delete()
                      .ignore();
                });
              });
            }
            _localNotificationService.showNotification(
                title: chatStore.name ?? 'Anonymous',
                body: decryptedMessageContent ?? '');
          } else {
            MessageStore messageStore = MessageStore(
                recipientEmail: message.recipientEmail,
                chatId: chatId!,
                contents: decryptedMessageContent ?? '',
                isSeen: message.isSeen,
                senderEmail: message.senderEmail,
                time: message.time);

            _messageDatabaseHelper
                .insertMessage(messageStore)
                .then((value) async {
              // chatStore.mostRecentMessage = messageStore;
              _chatDatabaseHelper
                  .updateChatMessages(messageStore, chatId!)
                  .then((_) {
                _firestore
                    .collection('messages')
                    .doc(message.id!)
                    .delete()
                    .ignore();
              });
            });
          }
          _localNotificationService.showNotification(
              title: chatStore.name ?? 'Anonymous',
              body: decryptedMessageContent);
        });
      });
    }
  }
  // debugPrint("Handling a background message: ${message.messageId}");
  // debugPrint("Title: ${message.notification?.title}");
  // debugPrint("Body: ${message.notification?.body}");
  // debugPrint("Payload: ${message.data}");
  // return;
}

Future<void> onMessageRecieved(RemoteMessage message) async {
  // debugPrint('Title: ${message.notification!.title}');
  // debugPrint('Body: ${message.notification!.body}');
  // debugPrint('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.subscribeToTopic(AddNewUser.signedInUser!.email!
        .replaceAll('@', '_')); //? Subscribing to listen to just my email
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    final fCMToken = await _firebaseMessaging.getToken();
    print(fCMToken);
    // GetMessages().setData(fCMTokenRegisteredName, fCMToken!);
    _messageDatabaseHelper.initializeDatabase();
    _chatDatabaseHelper.initializeDatabase();
    _localNotificationService.initialize();
    FirebaseMessaging.onMessage.listen(onMessageRecieved);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
