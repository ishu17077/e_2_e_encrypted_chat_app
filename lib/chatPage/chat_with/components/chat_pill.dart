import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';

class ChatPill extends StatelessWidget {
  final String? text;
  final bool isSeen;
  final bool? isMe;
  final bool isLastMessage;
  // final GlobalKey contextKey;
  final bool noMaginRequired;

  const ChatPill({
    super.key,
    required this.text,
    this.isSeen = false,
    this.noMaginRequired = false,
    this.isLastMessage = false,
    // required this.contextKey,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 6.5,
        right: 6.5,
        bottom: noMaginRequired ? 1.0 : 6.0,
        top: 1.0,
      ),
      child: Column(children: [
        Align(
          alignment:
              isMe ?? false ? Alignment.bottomRight : Alignment.bottomLeft,
          heightFactor: 1,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    text ?? '',
                    maxLines: 10,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                    softWrap: true,
                  ),
                ),
                const SizedBox(width: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: isMe ?? false
                      ? isSeen
                          ? const Icon(
                              Icons.done_all,
                              color: Colors.blue,
                              size: 12,
                            )
                          : const Icon(
                              Icons.done,
                              color: Colors.grey,
                              size: 17,
                            )
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ),
        isLastMessage
            ? SizedBox(height: MediaQuery.of(context).size.height * 0.06)
            : const SizedBox(),
      ]),
    );
  }
}
