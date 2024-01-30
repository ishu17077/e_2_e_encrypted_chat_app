import 'dart:async';

import 'package:e_2_e_encrypted_chat_app/encryption/encryption.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

EncryptedSharedPreferences _encryptedSharedPreferences =
    EncryptedSharedPreferences();

class EncryptionMethods {
  static Future<String> generateAndStoreKeysJwk() async {
    String? jwbPublicKey;

    final jwb = await generateKeys();
    await _encryptedSharedPreferences
        .setString('private_key_jwb', jwb.privateKey)
        .then((success) {
      if (success) {
        jwbPublicKey = jwb.publicKey;
      } else {
        throw Exception("Behenchod kya ho rha ha save kahe nhi ho rha ha");
      }
    });
    return jwbPublicKey!;
  }

  static Future<String?> getPrivateKeyJwk() async {
    String? privateKeyJwb;
    await _encryptedSharedPreferences
        .getString('private_key_jwb')
        .then((value) {
      privateKeyJwb = value;
    });
    return privateKeyJwb;
  }

  static Future<List<int>> getDerivedKey(
      String privateKeyJwk, String publicKeyJwk) async {
    final derivedKey = await deriveKey(privateKeyJwk, publicKeyJwk);
    return derivedKey;
  }
}
