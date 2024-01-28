import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String recipientEmail;
  DateTime time;
  String senderEmail;
  Uint8List iv;
  String contents;
  bool isSeen;
  Message({
    required this.recipientEmail,
    required this.time,
    required this.senderEmail,
    required this.iv,
    required this.contents,
    required this.isSeen,
  });
  toJson() => {
        'sender_email': senderEmail,
        'recipient_email': recipientEmail,
        'is_seen': isSeen,
        'contents': contents,
        'iv': utf8.decode(iv),
        'time': Timestamp.fromDate(time),
      };
  factory Message.fromJson(Map<String, dynamic> messageMap) {
    final Message message = Message(
      senderEmail: messageMap['sender_email'],
      recipientEmail: messageMap['recipient_email'],
      // ignore: unnecessary_cast
      time: (messageMap['time'] ?? Timestamp.now() as Timestamp).toDate(),
      iv: utf8.encode(messageMap['iv']),
      contents: messageMap['contents'] ?? '',
      isSeen: messageMap['is_seen'] ?? false,
    );
    return message;
  }
}
