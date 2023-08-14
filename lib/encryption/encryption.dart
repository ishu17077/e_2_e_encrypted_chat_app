import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:webcrypto/webcrypto.dart';

Future<JsonWebKeyPair> generateKeys() async {
  final keyPair = await EcdhPrivateKey.generateKey(EllipticCurve.p256);
  final publicKeyJwk = await keyPair.publicKey.exportJsonWebKey();
  final privateKeyJwk = await keyPair.privateKey.exportJsonWebKey();
  //! Only in testing
  print(json.encode(publicKeyJwk));
  print(json.encode(privateKeyJwk));
  return JsonWebKeyPair(
      publicKey: json.encode(publicKeyJwk),
      privateKey: json.encode(privateKeyJwk));
}

//? Model class for storing keys
class JsonWebKeyPair {
  final String publicKey;
  final String privateKey;

  const JsonWebKeyPair({
    required this.publicKey,
    required this.privateKey,
  });
}

//? SendersJwk -> sender.privateKey
//? ReceiverJwk -> receiver.publicKey
Future<List<int>> deriveKey(String senderJwk, String recieverJwk) async {
  //? Sender's Key
  final senderPrivateKey = json.decode(senderJwk);
  final senderEcdhKey = await EcdhPrivateKey.importJsonWebKey(
    senderPrivateKey,
    EllipticCurve.p256,
  );
  final recieverPublicKey = json.decode(recieverJwk);
  final recieverEcdhKey = await EcdhPublicKey.importJsonWebKey(
    recieverPublicKey,
    EllipticCurve.p256,
  );
  //? Generating CryptoKey
  final derivedBits = await senderEcdhKey.deriveBits(256, recieverEcdhKey);
  return derivedBits;
}

//? The "iv" stands for initialization vector (IV).
//! To ensure the encryption’s strength, each encryption process must use a random and distinct IV.
//? It’s included in the message so that the decryption procedure can use it.
Future<String> encryptMessage(
    {required Uint8List iv,
    required String messageContents,
    required List<int> deriveKey}) async {
  //? Importing cryptoKey
  final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(deriveKey);

  //? Converting message into bytes
  final messageContentsBytes = Uint8List.fromList(messageContents.codeUnits);

  //?Encrypting the message
  final encryptedMessageContentsBytes =
      await aesGcmSecretKey.encryptBytes(messageContentsBytes, iv);
  final encryptedMessageContents =
      String.fromCharCodes(encryptedMessageContentsBytes);
  return encryptedMessageContents;
}

Future<String> decryptedMessage(
    {required Uint8List iv,
    required String encryptedMessageContents,
    required List<int> deriveKey}) async {
  //? Importing cryptoKey
  final aesGcmSecretKey = await AesGcmSecretKey.importRawKey(deriveKey);

  //? Converting message into bytes
  final messageContentsBytes =
      Uint8List.fromList(encryptedMessageContents.codeUnits);

  //? Decypting the message
  final decryptedMessageContenrsBytes =
      await aesGcmSecretKey.decryptBytes(messageContentsBytes, iv);

  //? Converting decrypted message into string
  final decryptedMessage = String.fromCharCodes(decryptedMessageContenrsBytes);
  return decryptedMessage;
}
