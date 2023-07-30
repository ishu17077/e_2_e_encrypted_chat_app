import 'package:e_2_e_encrypted_chat_app/chatPage/add_new_chat_page.dart';
import 'package:e_2_e_encrypted_chat_app/chatPage/chat_with/chat_with_page.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/add_new_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:e_2_e_encrypted_chat_app/chatPage/chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final user = await AddNewUser.signedInUser;
  print(user?.email);
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ishu\'s Chat App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: greenAndroid,

        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff0cf3e1),
        ),
      ),
      home: const ChatWithPage(),
    );
  }
}
