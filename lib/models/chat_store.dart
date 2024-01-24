class ChatStore {
  String? get id => _id;
  String? _id;
  String belongsToEmail;
  String photoUrl;
  String chatId;

  ChatStore({
    required this.belongsToEmail,
    required this.photoUrl,
    required this.chatId,
  });

  toJson() => {
        'belongs_to_email': belongsToEmail,
        'photo_url': photoUrl,
        'chat_id': chatId,
      };

  factory ChatStore.fromJson(Map<String, dynamic> chatStoreMap) {
    final ChatStore chatStore = ChatStore(
        belongsToEmail: chatStoreMap['belongs_to_email'],
        photoUrl: chatStoreMap['photo_url'],
        chatId: chatStoreMap['chat_id']);
    return chatStore;
  }
}
