import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:e_2_e_encrypted_chat_app/serverFunctions/add_new_user.dart';
import 'package:e_2_e_encrypted_chat_app/authenticaltion_pages/email_and_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final _addNewUser = AddNewUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/sign_in_logo.png',
                height: 250,
                width: 300,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.12),
                child: const Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            signInButton(
              context,
              text: "Continue with Google :)",
              spaceBetween: 0.0,
              color: const Color.fromARGB(220, 255, 255, 255),
              imagePath: 'assets/google_icon.png',
              heightImage: 38.0,
              widthImage: 38.0,
              onPressed: () async {
                // _addNewUser.signedInUser;
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  UserCredential userCredential =
                      await _addNewUser.signInWithGoogle;
                  print(userCredential.user?.displayName);
                  print(FirebaseAuth.instance.currentUser?.displayName);
                } else {
                  print("You are already logged in asshole!!");
                  print(user.displayName);
                  print(user.email);
                  print(user.phoneNumber);
                }
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            signInButton(
              context,
              text: "Continue with Facebook",
              spaceBetween: 5.0,
              color: const Color.fromARGB(220, 24, 119, 242),
              textColor: Colors.white,
              imagePath: 'assets/facebook_icon.png',
              heightImage: 32.0,
              widthImage: 32.0,
              onPressed: () {},
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            signInButton(
              context,
              text: "Continue with Mail ;)",
              color: const Color.fromARGB(255, 70, 62, 88),
              textColor: Colors.white38,
              imagePath: 'assets/email_icon.png',
              heightImage: 31.7,
              widthImage: 31.7,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EmailAndPasswordAuthentication(),
              )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.017),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: const Text(
                    "Need Help?",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    print("Hello!!");
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget signInButton(BuildContext context,
      {String? text,
      Color? color,
      Color? textColor,
      String? imagePath,
      double? spaceBetween,
      double? heightImage,
      double? widthImage,
      VoidCallback? onPressed}) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: color,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8,
              MediaQuery.of(context).size.height * 0.05),
          maximumSize: Size(MediaQuery.of(context).size.width * 0.80,
              MediaQuery.of(context).size.height * 0.055),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imagePath != null
                ? Image.asset(imagePath,
                    height: heightImage ?? 38.0, width: widthImage ?? 38.0)
                : const SizedBox(),
            SizedBox(width: spaceBetween ?? 5.0),
            Align(
              alignment: Alignment.center,
              child: Text(
                text ?? 'How about continuing with some brain ;D',
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
