abstract class IEncryption {
  Future<String> encrypt(String text);
  Future<String> decrypt(String encryptedText);
}
