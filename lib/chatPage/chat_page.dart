import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Conversations",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      color: kSexyTealColor.withOpacity(0.8),
                      elevation: 5,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add,
                            color: kBackgroundColor,
                          ),
                          Text(
                            'Add New',
                            style: TextStyle(color: kBackgroundColor),
                          ),
                        ],
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
