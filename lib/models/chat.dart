import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String? get id => _id;
  String? _id;
  String chatWithEmail;
  List<String?> belongsToEmails;
  int unreadMessages;
  DateTime lastOnline;
  List<String?> photoUrls;
  String chatId;
  String? lastMessage;
  List<String?> chatNames;
  Chat({
    required this.chatWithEmail,
    required this.unreadMessages,
    required this.lastOnline,
    required this.photoUrls,
    required this.belongsToEmails,
    required this.chatId,
    required this.chatNames,
    this.lastMessage = '',
  });
  toJson() => {
        'chat_with_email': chatWithEmail,
        'belongs_to_emails': belongsToEmails,
        'unread_messages': unreadMessages,
        'last_online': lastOnline,
        'chat_names': chatNames,
        'photo_urls': photoUrls,
        'last_message': lastMessage,
        'chat_id': chatId,
      };
  factory Chat.fromJson(Map<String, dynamic> json) {
    final Chat chat = Chat(
      chatWithEmail: json['chat_with_email'],
      photoUrls: List.castFrom(json['photo_urls'] as List),
      lastOnline:
          // ignore: unnecessary_cast
          (json['last_online'] ?? Timestamp.now() as Timestamp).toDate(),
      belongsToEmails: List.castFrom(json['belongs_to_emails'] as List),
      chatNames: List.castFrom(json['chat_names'] as List) ?? [''],
      chatId: json['chat_id'],
      unreadMessages: json['unread_messages'],
      lastMessage: json['last_message'],
    );
    return chat;
  }
}
