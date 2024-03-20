class MessageStore {
  int? get id => _id;
  int? _id;
  String recipientEmail;
  int chatId;
  DateTime time;
  String senderEmail;
  String? messageIdFromServer;
  String contents;
  bool isSeen;

  MessageStore({
    required this.recipientEmail,
    required this.chatId,
    required this.contents,
    required this.isSeen,
    required this.senderEmail,
    required this.time,
  });

  MessageStore.withId(
    this._id, {
    required this.recipientEmail,
    required this.chatId,
    required this.contents,
    required this.isSeen,
    required this.senderEmail,
    required this.time,
  });
  MessageStore.withMessageServerId({
    required this.chatId,
    required this.contents,
    required this.isSeen,
    required this.messageIdFromServer,
    required this.recipientEmail,
    required this.senderEmail,
    required this.time,
  });
  toJson() => {
        'chat_id': chatId,
        'contents': contents,
        'is_seen': isSeen.toString() ?? 'false',
        'sender_email': senderEmail,
        'time': time.toString(),
        'message_id_from_server': messageIdFromServer,
        'recipient_email': recipientEmail,
      };
  factory MessageStore.fromJson(Map<String, dynamic> messageStoreMap) {
    final MessageStore messageStore = MessageStore.withId(
      messageStoreMap['id'],
      recipientEmail: messageStoreMap['recipient_email'],
      chatId: int.parse(messageStoreMap['chat_id']),
      contents: messageStoreMap['contents'],
      isSeen: messageStoreMap['is_seen'] == 'true' ? true : false,
      senderEmail: messageStoreMap['sender_email'],
      // ignore: unnecessary_cast
      time: DateTime.parse(messageStoreMap['time']),
    );
    return messageStore;
  }
}
