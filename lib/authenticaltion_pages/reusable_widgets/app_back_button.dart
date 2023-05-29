import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_sharp,
        size: 30,
        color: Colors.white38,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
