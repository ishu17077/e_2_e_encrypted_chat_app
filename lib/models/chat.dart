import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? get id => _id;
  String? _id;
  String chatWithEmail;
  List<String?> belongsToEmails;
  int unreadMessages;
  DateTime lastOnline;
  String photoUrl;
  String chatId;
  String? lastMessage;
  String? chatName;
  Chat({
    required this.chatWithEmail,
    required this.unreadMessages,
    required this.lastOnline,
    required this.photoUrl,
    required this.belongsToEmails,
    required this.chatId,
    required this.chatName,
    this.lastMessage = '',
  });
  toJson() => {
        'chat_with_email': chatWithEmail,
        'belongs_to_emails': belongsToEmails,
        'unread_messages': unreadMessages,
        'last_online': lastOnline,
        'chat_name': chatName,
        'photo_url': photoUrl,
        'last_message': lastMessage,
        'chat_id': chatId,
      };
  factory Chat.fromJson(Map<String, dynamic> json) {
    final Chat chat = Chat(
      chatWithEmail: json['chat_with_email'],
      photoUrl: json['photo_url'] ?? '',
      lastOnline:
          // ignore: unnecessary_cast
          (json['last_online'] ?? Timestamp.now() as Timestamp).toDate(),
      belongsToEmails: List.castFrom(json['belongs_to_emails'] as List),
      chatName: json['chat_name'],
      chatId: json['chat_id'],
      unreadMessages: json['unread_messages'],
      lastMessage: json['last_message'],
    );
    return chat;
  }
}
