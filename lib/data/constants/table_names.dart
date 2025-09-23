class ChatTable {
  static const String chatsTable = 'chats';
  static const String colId = 'id';
  static const String colEmail = 'email';
  static const String colUsername = "username";
  static const String colPhotoUrl = 'photo_url';
  static const String colName = 'name';
  static const String colUserIdFromServer = 'server_id';
  static const String colCreatedAt = "created_at";
}

class MessageTable {
  static const String messagesTable = 'messages';
  static const String colId = 'id';
  static const String colRecipient = 'recepient';
  static const String colChatId = 'chat_id';
  static const String colExecutedAt = "executed_at";
  static const String colCreatedAt = "created_at";
  static const String colSender = 'sender';
  static const String colContents = 'contents';
  static const String colReceipt = 'receipt';
}
