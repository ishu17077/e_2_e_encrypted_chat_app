import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secuchat/data/constants/table_names.dart';
import 'package:chat/chat.dart';

class LocalMessage {
  String? chatId;
  String? userId;
  String get id => _id!;
  String? _id;
  Message message;
  Receipt receipt;

  LocalMessage(this.message, this.receipt, {this.chatId, this.userId})
      : assert(chatId != null || userId != null,
            "Both user_id and chat_id cannot be null");

  Map<String, dynamic> toJSON() => {
        MessageTable.colChatId: chatId,
        MessageTable.colSender: message.from,
        MessageTable.colRecipient: message.to,
        MessageTable.colContents: message.contents,
        MessageTable.colExecutedAt: Timestamp.fromDate(receipt.time),
        MessageTable.colReceipt: receipt.status.value(),
        MessageTable.colCreatedAt: message.time.toString(),
      };

  factory LocalMessage.fromJSON(Map<String, dynamic> messageMap) {
    final Message message = Message(
      from: messageMap[MessageTable.colSender] ?? '',
      to: messageMap[MessageTable.colReceipt] ?? '',
      contents: messageMap[MessageTable.colContents] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(
          (messageMap[MessageTable.colExecutedAt])),
    );
    final LocalMessage localMessage = LocalMessage(
      message,
      ReceiptStatusParsing.fromString(messageMap["receipt"]),
      chatId: messageMap["chat_id"]!,
    );
    localMessage._id = messageMap["id"];
    return localMessage;
  }
}
