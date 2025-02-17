import 'package:e_2_e_encrypted_chat_app/chatPage/chat_page.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AppBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_sharp,
        size: 30,
        color: Colors.white38,
      ),
      onPressed: onPressed,
    );
  }
}
