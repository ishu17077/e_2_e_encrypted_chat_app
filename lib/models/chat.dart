import 'package:chat/chat.dart';
import 'package:e_2_e_encrypted_chat_app/data/constants/table_names.dart';
import 'package:e_2_e_encrypted_chat_app/models/local_message.dart';

class Chat {
  String get() => _id;
  late String _id;
  final String userId;
  int unread = 0;
  List<LocalMessage> messages = [];

  LocalMessage? mostRecent;

  User? from;

  Chat(this.userId, {List<LocalMessage>? messages, this.mostRecent})
      : messages = messages ?? [];

  Map<String, String?> toJSON() => {
        ChatTable.colCreatedAt: DateTime.now().toString(),
        ChatTable.colUserId: userId,
      };

  factory Chat.fromJSON(Map<String, dynamic> chatMap) {
    final chat = Chat(
      chatMap[ChatTable.colUserId],
    );
    chat._id = chatMap["id"];
    return chat;
  }
}
