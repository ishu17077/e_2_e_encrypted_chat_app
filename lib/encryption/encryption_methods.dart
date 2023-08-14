import 'dart:async';

import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences();

class EncryptionMethods {
  static Future<String?> generateAndStoreKeysJwk() async {
    String? jwbPublicKey;

    final jwb = await generateKeys();
    encryptedSharedPreferences
        .setString('private_key_jwb', jwb.privateKey)
        .then((bool success) {
      if (success) {
        jwbPublicKey = jwb.publicKey;
      } else {
        throw Exception();
      }
    });
    return jwbPublicKey;
  }

  static Future<String?> getPrivateKeyJwk() async {
    String? privateKeyJwb;
    encryptedSharedPreferences.getString('private_key_jwb').then((value) {
      privateKeyJwb = value;
    });
    return privateKeyJwb;
  }

  static Future<List<int>> getDerivedKey(
      String senderPrivateKeyJwk, String receiverPublicKeyJwk) async {
    final derivedKey = await deriveKey(senderPrivateKeyJwk, receiverPublicKeyJwk);
    return derivedKey;
  }
}
