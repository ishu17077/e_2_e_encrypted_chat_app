import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secuchat/ui/pages/onboarding/onboarding_router.dart';
import 'package:secuchat/unit_components.dart';

class Onboarding extends StatefulWidget {
  final IOnboardingRouter router;
  const Onboarding(this.router, {super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  bool isLoadingWithGoogle = false;
  bool isLoadingWithFacebook = false;
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
            Stack(
              children: [
                signInButton(
                  context,
                  text: "Continue with Google :)",
                  spaceBetween: 0.0,
                  color: const Color.fromARGB(220, 255, 255, 255),
                  imagePath: 'assets/google_icon.png',
                  heightImage: 38.0,
                  widthImage: 38.0,
                  onPressed: () async {
                    if (!isLoadingWithFacebook || !isLoadingWithGoogle) {
                      final user = AddNewUser.signedInUser;
                      setState(() {
                        isLoadingWithGoogle = true;
                      });
                      if (user == null) {
                        UserCredential userCredential =
                            await _addNewUser.signInWithGoogle.then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage()),
                              (route) => false);
                          return value;
                        }).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Ya toh net kharab ha ya toh dimag ya toh Google ka server')));
                          FirebaseAuth.instance.signOut();
                          setState(() {
                            isLoadingWithGoogle = false;
                          });

                          throw Exception();
                        });
                        print(userCredential.user?.displayName);
                        print(FirebaseAuth.instance.currentUser?.displayName);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(),
                            ));
                        print("You are already logged in asshole!!");
                        print(user.displayName);
                        print(user.email);
                        print(user.phoneNumber);
                      }
                      setState(() {
                        isLoadingWithGoogle = false;
                      });
                    }
                  },
                ),
                isLoadingWithGoogle
                    ? const Center(
                        heightFactor: 1.4, child: CircularProgressIndicator())
                    : const SizedBox(height: 0.0, width: 0.0)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Stack(
              children: [
                signInButton(
                  context,
                  text: "Continue with Facebook",
                  spaceBetween: 5.0,
                  color: const Color.fromARGB(220, 24, 119, 242),
                  textColor: Colors.white,
                  imagePath: 'assets/facebook_icon.png',
                  heightImage: 32.0,
                  widthImage: 32.0,
                  onPressed: () {
                    if (!isLoadingWithGoogle && !isLoadingWithFacebook) {
                      setState(() {
                        isLoadingWithFacebook = true;
                      });
                      FirebaseAuth.instance.signOut();
                      setState(() {
                        isLoadingWithFacebook = false;
                      });
                    }
                  },
                ),
                isLoadingWithFacebook
                    ? const Center(
                        heightFactor: 1.4, child: CircularProgressIndicator())
                    : const SizedBox(height: 0.0, width: 0.0)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Stack(
              children: [
                signInButton(
                  context,
                  text: "Continue with Mail ;)",
                  color: const Color.fromARGB(255, 70, 62, 88),
                  textColor: Colors.white38,
                  imagePath: 'assets/email_icon.png',
                  heightImage: 31.7,
                  widthImage: 31.7,
                  onPressed: () {
                    if (!isLoadingWithGoogle && !isLoadingWithFacebook) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const EmailAndPasswordAuthentication(),
                      ));
                    }
                  },
                ),
              ],
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
