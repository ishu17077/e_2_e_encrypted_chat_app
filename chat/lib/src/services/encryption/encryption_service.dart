import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:encrypt/encrypt.dart';

final class EncryptionService implements IEncryption {
  final Encrypter _encrypter;
  final _iv = IV.fromLength(16);

  EncryptionService(this._encrypter);

  @override
  String decrypt(String encryptedText) {
    late final message;
    try {
      final encrypted = Encrypted.fromBase64(encryptedText);
      message = _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      message = "This message can't be decrypted.";
    }
    return message;
  }

  @override
  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: _iv).base64;
  }
}
