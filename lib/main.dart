import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/sign_up_page.dart';
import 'package:e_2_e_encrypted_chat_app/notifications/firebase_api.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final user = AddNewUser.signedInUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      await FlutterLocalNotificationsPlugin();
  localNotificationsPlugin.cancelAll();
  await Firebase.initializeApp();
  if (user != null) {
    await FirebaseApi().initNotifications();
  } //? initialize notification for them
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final MaterialColor greenAndroid =
      const MaterialColor(0xff3ddc84, <int, Color>{
    50: Color(0xff37c677),
    100: Color(0xff31b06a),
    200: Color(0xff2b9a5c),
    300: Color(0xff25844f),
    400: Color(0xff1f6e42),
    500: Color(0xff185835),
    600: Color(0xff124228),
    700: Color(0xff0c2c1a),
    800: Color(0xff06160d),
    900: Color(0xff000000),
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Ishu\'s Chat App',
      theme: ThemeData(
        primarySwatch: greenAndroid,
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff0cf3e1),
        ),
      ),
      home: user != null ? ChatPage() : SignUpPage(),
    );
  }
}
