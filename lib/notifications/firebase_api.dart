import 'package:e_2_e_encrypted_chat_app/server_functions/get_messages.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print("Handling a background message: ${message.messageId}");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");

}

Future<void> onMessageRecieved(RemoteMessage message) async {
  print('Title: ${message.notification!.title}');
  print('Body: ${message.notification!.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fCMToken = await _firebaseMessaging.getToken();
    print(fCMToken);
    // GetMessages().setData(fCMTokenRegisteredName, fCMToken!);
    FirebaseMessaging.onMessage.listen(onMessageRecieved);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    ;
  }
}
