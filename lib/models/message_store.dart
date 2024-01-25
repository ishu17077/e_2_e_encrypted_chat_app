import 'package:cloud_firestore/cloud_firestore.dart';

class MessageStore {
  String? get id => _id;
  String? _id;
  String recepientEmail;
  String chatId;
  DateTime time;
  String senderEmail;
  String contents;
  bool isSeen;

  MessageStore({
    required this.recepientEmail,
    required this.chatId,
    required this.contents,
    required this.isSeen,
    required this.senderEmail,
    required this.time,
  });

  MessageStore.withId(
    this._id, {
    required this.recepientEmail,
    required this.chatId,
    required this.contents,
    required this.isSeen,
    required this.senderEmail,
    required this.time,
  });

  toJson() => {
        'chat_id': chatId,
        'contents': contents,
        'is_seen': isSeen,
        'sender_email': senderEmail,
        'time': Timestamp.fromDate(time).toString(),
        'recepient_email': recepientEmail,
      };
  factory MessageStore.fromJson(Map<String, dynamic> messageStoreMap) {
    final MessageStore messageStore = MessageStore.withId(
      messageStoreMap['id'],
      recepientEmail: messageStoreMap['recepient_email'],
      chatId: messageStoreMap['chat_id'],
      contents: messageStoreMap['contents'],
      isSeen: messageStoreMap['is_seen'],
      senderEmail: messageStoreMap['sender_email'],
      time: (messageStoreMap['time'] ?? Timestamp.now() as Timestamp).toDate(),
    );
    return messageStore;
  }
}
