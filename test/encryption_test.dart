import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:e_2_e_encrypted_chat_app/models/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  //? Dummy Message
  var random = Random.secure();
  List<int> _ivList = List<int>.generate(8, (_) => random.nextInt(99));
  // print(_ivList.toString());
  Uint8List _iv = Uint8List.fromList(_ivList);
  print(_iv.toString());
  Message message = Message(
    recipientEmail: 'Lalaba@testmail.com',
    time: DateTime.now(),
    iv: _iv,
    senderEmail: 'anon@testmail.com',
    contents: 'Hey?? How you doing💩💩💩💩💩💩💩💩💩💩💩💩💩💩💩',
    isSeen: false,
  );
  final messageSendJson = message.toJson();
  final messageSend = Message.fromJson(messageSendJson);
  final jwb = await generateKeys();
  final deriveKeyVar = await deriveKey(jwb.privateKey, jwb.publicKey);
  final Message messageReceived = Message.fromJson({
    'sender_email': 'anon@testmail.com',
    'recipient_email': 'Lalaba@testmail.com',
    'is_seen': false,
    'contents': await encryptMessage(
        iv: _iv, messageContents: message.contents, deriveKey: deriveKeyVar),
    'iv': utf8.decode(_iv),
    'time': Timestamp.now(),
    'chat_id': 12212,
  });
  // final Uint8List iv = Uint8List.fromList(message.chatId.codeUnits);

  //? Self-message where both reciever and sender is me

  test('Check for message encryption and decryption', () async {
    print("\x1B[34mMessage Contents: ${message.contents}\x1B[0m");
    print(
        "\x1B[36mEncrypting with public key: \x1B[35m${jwb.publicKey}\x1B[0m ");
    final String encryptedMessageContents = await encryptMessage(
        iv: _iv,
        messageContents: messageSend.contents,
        deriveKey: deriveKeyVar);
    print("\x1B[33mEncrypted message: $encryptedMessageContents\x1B[0m");
    print(
        "\x1B[36mDecrypting message \'$encryptedMessageContents\' with private key: \x1B[31m${jwb.privateKey}\x1B[0m ");
    final String decryptedMessageContents = await decryptedMessage(
        iv: messageReceived.iv,
        encryptedMessageContents: encryptedMessageContents,
        deriveKey: deriveKeyVar);
    print("\x1B[32mDecrypted message: $decryptedMessageContents\x1B[0m");
    expectLater(decryptedMessageContents, messageSend.contents);
  });
}
