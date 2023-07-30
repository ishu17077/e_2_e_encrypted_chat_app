import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';

class ChatPill extends StatelessWidget {
  String? text;
  bool isSeen;
  bool? isMe;

  ChatPill({super.key, this.text, this.isSeen = false, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.5),
      child: Column(children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            constraints: BoxConstraints(
                minWidth: 0,
                maxWidth: MediaQuery.of(context).size.width * 0.62,
                minHeight: 28,
                maxHeight: double.infinity),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.5),
            decoration: ShapeDecoration(
              color: isMe ?? false ? Colors.black45 : kSubHeadingColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide.none),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: 1,
              heightFactor: 1,
              child: Text(
                text ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ),
        isMe ?? false
            ? isSeen
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Seen  ",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Icon(
                        Icons.done_all,
                        color: Colors.blue,
                        size: 12,
                      ),
                    ],
                  )
                : const Icon(
                    Icons.done,
                    color: Colors.grey,
                    size: 17,
                  )
            : Container(),
      ]),
    );
  }
}
