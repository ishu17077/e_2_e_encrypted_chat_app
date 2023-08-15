import 'dart:typed_data';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:e_2_e_encrypted_chat_app/models/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  //? Dummy Message
  Message message = Message(
    recepientEmail: 'Lalaba@testmail.com',
    time: DateTime.now(),
    chatId: '0W5fvWskonvemsu7KIDM',
    senderEmail: 'anon@testmail.com',
    contents: 'Hey?? How you doing',
    isSeen: false,
  );

  final Uint8List iv = Uint8List.fromList(message.chatId.codeUnits);
  final jwb = await generateKeys();
  //? Self-message where both reciever and sender is me
  final deriveKeyVar = await deriveKey(jwb.privateKey, jwb.publicKey);
  test('Check for message encryption and decryption', () async {
    print("\x1B[34mMessage Contents: ${message.contents}\x1B[0m");
    print(
        "\x1B[36mEncrypting with public key: \x1B[35m${jwb.publicKey}\x1B[0m ");
    final String encryptedMessageContents = await encryptMessage(
        iv: iv, messageContents: message.contents, deriveKey: deriveKeyVar);
    print("\x1B[33mEncrypted message: $encryptedMessageContents\x1B[0m");
    print(
        "\x1B[36mDecrypting message \'$encryptedMessageContents\' with private key: \x1B[31m${jwb.privateKey}\x1B[0m ");
    final String decryptedMessageContents = await decryptedMessage(
        iv: iv,
        encryptedMessageContents: encryptedMessageContents,
        deriveKey: deriveKeyVar);
    print("\x1B[32mDecrypted message: $decryptedMessageContents\x1B[0m");
    expectLater(decryptedMessageContents, message.contents);
  });
}
