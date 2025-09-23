import 'package:chat/chat.dart';
import 'package:e_2_e_encrypted_chat_app/data/constants/table_names.dart';
import 'package:e_2_e_encrypted_chat_app/models/local_message.dart';

class Chat {
  final String id;
  int unread = 0;
  List<LocalMessage> messages = [];

  LocalMessage? mostRecent;

  final User from;

  Chat(this.id, this.from, {List<LocalMessage>? messages, this.mostRecent})
      : messages = messages ?? [];

  Map<String, String?> toJSON() => {
        ChatTable.colId: id,
        ChatTable.colEmail: from.email,
        ChatTable.colName: from.name,
        ChatTable.colPhotoUrl: from.photoUrl,
        ChatTable.colUserIdFromServer: from.id,
      };

  factory Chat.fromJSON(Map<String, dynamic> chatMap) {
    return Chat(
      chatMap["id"],
      User(
        email: chatMap[ChatTable.colEmail],
        lastSeen: DateTime(1997),
        name: chatMap[ChatTable.colName],
        username: chatMap[ChatTable.colUsername],
        photoUrl: chatMap[ChatTable.colPhotoUrl],
      ),
    );
  }
}
