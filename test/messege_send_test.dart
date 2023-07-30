import 'package:e_2_e_encrypted_chat_app/models/message.dart';
import 'package:e_2_e_encrypted_chat_app/server_functions/get_messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  await Firebase.initializeApp();
  Message message = Message(
      chatId: '',
      recepient: 'Lololol',
      contents: 'Lambda',
      time: DateTime.now(),
      sender: 'Legends of Sex',
      isSeen: false);
  GetMessages getMessages = GetMessages();
  test('should send a message to Lololol sender', () async {
    final messageFromFirestore = await getMessages.sendMessage(message);
    print(messageFromFirestore);
    expect(messageFromFirestore, isNotEmpty);
  });
}
