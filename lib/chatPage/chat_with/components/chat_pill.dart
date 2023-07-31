import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';

class ChatPill extends StatelessWidget {
  String? text;
  bool isSeen;
  bool? isMe;
  bool noMaginRequired = false;

  ChatPill({
    super.key,
    required this.text,
    this.isSeen = false,
    this.noMaginRequired = false,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 6.5,
        right: 6.5,
        top: noMaginRequired ? 1.0 : 10,
        bottom: 1.0,
      ),
      child: Column(children: [
        Align(
          alignment:
              isMe ?? false ? Alignment.bottomRight : Alignment.bottomLeft,
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
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text ?? '',
                        maxLines: 10,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
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
        ),
      ]),
    );
  }
}
