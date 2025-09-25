import 'package:e_2_e_encrypted_chat_app/data/constants/table_names.dart';
import 'package:chat/chat.dart';

class LocalMessage {
  String? chatId;
  String get id => _id!;
  String? _id;
  Message message;
  ReceiptStatus receipt;

  LocalMessage(this.chatId, this.message, this.receipt);

  Map<String, dynamic> toJSON() => {
        MessageTable.colChatId: chatId,
        MessageTable.colSender: message.from,
        MessageTable.colRecipient: message.to,
        MessageTable.colContents: message.contents,
        //TODO: Impl
        // MessageTable.colCreatedAt
        MessageTable.colReceipt: receipt.value(),
        MessageTable.colExecutedAt: message.time.toString(),
      };

  factory LocalMessage.fromJSON(Map<String, dynamic> messageMap) {
    final Message message = Message(
      from: messageMap[MessageTable.colSender] ?? '',
      to: messageMap[MessageTable.colReceipt] ?? '',
      contents: messageMap[MessageTable.colContents] ?? '',
      time: DateTime.parse(messageMap[MessageTable.colExecutedAt]),
    );
    final LocalMessage localMessage = LocalMessage(
        messageMap[MessageTable.colChatId],
        message,
        ReceiptStatusParsing.fromString(messageMap["receipt"]));
    localMessage._id = messageMap["id"];
    return localMessage;
  }
}
