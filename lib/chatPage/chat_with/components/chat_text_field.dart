import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatTextField extends StatelessWidget {
  final Function onSendButtonPressed;
  ChatTextField({super.key, required this.onSendButtonPressed});
  final TextEditingController _textEditingController = TextEditingController();
  String? contents;
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
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        onChanged: (contents) {
          this.contents = contents;
        },
        style: TextStyle(color: Colors.white.withOpacity(0.9)),
        controller: _textEditingController,
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
                _textEditingController.clear();
                onSendButtonPressed(contents?.trimRight() ?? '');
              },
            )),
      ),
    );
  }
}
