class Chat {
  String? get id => _id;
  String? _id;
  List<String?> belongsToEmails;
  List<String?> photoUrls;
  String chatId;

  List<String?> chatNames;
  Chat({
    required this.photoUrls,
    required this.belongsToEmails,
    required this.chatId,
    required this.chatNames,
  });
  toJson() => {
        'belongs_to_emails': belongsToEmails,
        'chat_names': chatNames,
        'photo_urls': photoUrls,
        'chat_id': chatId,
      };
  factory Chat.fromJson(Map<String, dynamic> chatMap) {
    final Chat chat = Chat(
      photoUrls: List.castFrom(chatMap['photo_urls'] as List),
      belongsToEmails: List.castFrom(chatMap['belongs_to_emails'] as List),
      chatNames: List.castFrom(chatMap['chat_names'] as List) ?? ['', ''],
      chatId: chatMap['chat_id'],
    );
    return chat;
  }
}
