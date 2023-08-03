import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String recepientEmail;
  String chatId;
  DateTime time;
  String senderEmail;
  String contents;
  bool isSeen;
  Message({
    required this.recepientEmail,
    required this.time,
    required this.chatId,
    required this.senderEmail,
    required this.contents,
    required this.isSeen,
  });
  toJson() => {
        'sender_email': senderEmail,
        'recipient_email': recepientEmail,
        'is_seen': isSeen,
        'contents': contents,
        'time': time,
        'chat_id': chatId,
      };
  factory Message.fromJson(Map<String, dynamic> json) {
    final Message message = Message(
      senderEmail: json['sender_email'],
      recepientEmail: json['recipient_email'],
      // ignore: unnecessary_cast
      time: (json['time'] ?? Timestamp.now() as Timestamp).toDate(),
      contents: json['contents'] ?? '',
      isSeen: json['is_seen'] ?? false,
      chatId: json['chat_id'],
    );
    return message;
  }
}
