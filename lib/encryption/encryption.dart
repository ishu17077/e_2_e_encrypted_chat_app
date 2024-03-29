import 'dart:convert';
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

Future<List<int>> deriveKey(String privateKeyJwk, String publicKey) async {
  //? Sender's Key
  final senderPrivateKey = json.decode(privateKeyJwk);
  final senderEcdhKey = await EcdhPrivateKey.importJsonWebKey(
    senderPrivateKey,
    EllipticCurve.p256,
  );
  final recieverPublicKey = json.decode(publicKey);
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
  final messageContentsBytes = Uint8List.fromList(utf8.encode(
      messageContents)); //! messageContents.codeunits instead of utf8.encode(messageContents) was there i am checking if it fixes the emoji problem!! Dare i say it did fix it

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
  try {
    final decryptedMessageContenrsBytes =
        await aesGcmSecretKey.decryptBytes(messageContentsBytes, iv);

    //? Converting decrypted message into string
    final decryptedMessage =
        String.fromCharCodes(decryptedMessageContenrsBytes);
    return utf8.decode(decryptedMessage.codeUnits);
  } catch (e) {
    print("Cannot decrypt message");
    return 'This message cannot be decrypted';
  }
}
