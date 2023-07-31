import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? get id => _id;
  String? _id;
  String chatWith;
  String? belongsToEmail;
  int unreadMessages;
  DateTime lastTime;
  String photoUrl;
  String? chatId;
  String? lastMessage;
  String? chatName;
  Chat({
    required this.chatWith,
    required this.unreadMessages,
    required this.lastTime,
    required this.photoUrl,
    required this.belongsToEmail,
    required this.chatId,
    required this.chatName,
    this.lastMessage = '',
  });
  toJson() => {
        'chat_with': chatWith,
        'belongs_to_email': belongsToEmail,
        'unread_messages': unreadMessages,
        'last_time': lastTime,
        'chat_name': chatName,
        'photo_url': photoUrl,
        'last_message': lastMessage,
        'chat_id': chatId,
      };
  factory Chat.fromJson(Map<String, dynamic> json) {
    final Chat chat = Chat(
      chatWith: json['chat_with'],
      photoUrl: json['photo_url'] ?? '',
      lastTime: (json['last_time'] as Timestamp).toDate(),
      belongsToEmail: json['belongs_to_email'],
      chatName: json['chat_name'],
      chatId: json['chat_id'],
      unreadMessages: json['unread_messages'],
      lastMessage: json['last_message'],
    );
    return chat;
  }
}
