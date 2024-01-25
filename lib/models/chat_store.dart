import 'package:e_2_e_encrypted_chat_app/models/message_store.dart';

class ChatStore {
  String? get id => _id;
  String? _id;
  String belongsToEmail;
  String? name;
  String photoUrl;
  String chatId;
  MessageStore mostRecentMessage;

  ChatStore({
    required this.belongsToEmail,
    required this.photoUrl,
    required this.chatId,
    required this.mostRecentMessage,
    this.name,
  });

  toJson() => {
        'belongs_to_email': belongsToEmail,
        'photo_url': photoUrl,
        'chat_id': chatId,
        'most_recent_message': mostRecentMessage.toJson(),
        'name': name,
      };

  factory ChatStore.fromJson(Map<String, dynamic> chatStoreMap) {
    final ChatStore chatStore = ChatStore(
      belongsToEmail: chatStoreMap['belongs_to_email'],
      photoUrl: chatStoreMap['photo_url'],
      chatId: chatStoreMap['chat_id'],
      mostRecentMessage:
          MessageStore.fromJson(chatStoreMap['most_recent_message']),
          name: chatStoreMap['name'],
    );
    return chatStore;
  }
}
