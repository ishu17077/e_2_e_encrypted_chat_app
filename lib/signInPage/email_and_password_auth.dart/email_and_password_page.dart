import 'package:e_2_e_encrypted_chat_app/colors.dart';
import 'package:flutter/material.dart';

class EmailAndPasswordAuthentication extends StatelessWidget {
  const EmailAndPasswordAuthentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.069),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  size: 30,
                  color: Colors.white38,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.030,
                  top: MediaQuery.of(context).size.height * 0.02),
              child: const Text(
                "Create Account",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 38,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
