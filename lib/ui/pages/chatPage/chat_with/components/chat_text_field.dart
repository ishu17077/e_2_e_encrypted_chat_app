import 'package:secuchat/unit_components.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatTextField extends StatefulWidget {
  final Function onSendButtonPressed;
  ChatTextField({super.key, required this.onSendButtonPressed});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  bool shouldKeyBoardAppear = false;
  String? contents;
  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: 7.0, right: 7.0, top: 0.0, bottom: 0.0),
      margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromRGBO(76, 72, 90, 1),
      ),
      child: TextField(
        onTap: () {
          setState(() {
            shouldKeyBoardAppear = true;
          });
        },
        keyboardType: TextInputType.multiline,
        readOnly: !shouldKeyBoardAppear,
        controller: _textEditingController,
        minLines: 1,
        showCursor: true,
        autofocus: true,
        maxLines: 5,
        style: TextStyle(color: Colors.white.withOpacity(0.9)),
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.only(
                left: 1.0, right: 1.0, top: 10.0, bottom: 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
            prefixIcon: const Icon(
              Icons.text_fields_outlined,
              color: kSexyTealColor,
            ),
            suffixIcon: IconButton(
                icon: const Icon(
                  Icons.send_rounded,
                  color: kSexyTealColor,
                ),
                onPressed: () {
                  widget.onSendButtonPressed(
                      _textEditingController.value.text.trimRight().trimLeft());
                  contents = '';
                  _textEditingController.clear();
                })),
      ),
    );
  }
}
