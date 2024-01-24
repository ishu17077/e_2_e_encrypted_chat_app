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
  factory Message.fromJson(Map<String, dynamic> messageMap) {
    final Message message = Message(
      senderEmail: messageMap['sender_email'],
      recepientEmail: messageMap['recipient_email'],
      // ignore: unnecessary_cast
      time: (messageMap['time'] ?? Timestamp.now() as Timestamp).toDate(),
      contents: messageMap['contents'] ?? '',
      isSeen: messageMap['is_seen'] ?? false,
      chatId: messageMap['chat_id'],
    );
    return message;
  }
}
