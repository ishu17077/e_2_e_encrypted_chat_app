import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:chat/src/services/encryption/encryption_service.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late IEncryption sut;

  setUpAll(() {
    final encrypter = Encrypter(AES(Key.fromLength(32)));
    sut = EncryptionService(encrypter);
  });

  void printText(String text) {
    print("Message: \x1B[33m$text\x1B[0m");
  }

  void printEncryptedText(String encryptedText) {
    print("Encrypted Text: \x1B[32m$encryptedText\x1B[0m");
  }

  test("Encrypts plain text", () {
    final String text = "Yooo!";
    final base64 = RegExp(
      r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$',
    );

    final encryptedText = sut.encrypt(text);
    expect(base64.hasMatch(encryptedText), true);
  });

  test("Decrypts the plain text", () {
    final String text = "It's Cool";

    final encryptedText = sut.encrypt(text);

    final decryptedText = sut.decrypt(encryptedText);

    expect(decryptedText, text);
  });
}
