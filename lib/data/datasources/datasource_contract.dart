import 'package:chat/chat.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';
import 'package:e_2_e_encrypted_chat_app/models/local_message.dart';

abstract class IDataSource {
  Future<void> addChat(Chat chat);
  Future<void> addMessage(LocalMessage message);
  Future<Chat> findChat(String chatId);
  Future<List<Chat>> findAllChats();
  Future<void> updateMessage();
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> deleteChat(String chatId);
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status);
}
