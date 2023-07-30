class Chat {
  String? get id => _id;
  String? _id;
  String chatWith;
  int unreadMessages;
  DateTime lastTime;
  String? chatId;
  String? lastMessage;
  Chat({
    required this.chatWith,
    required this.unreadMessages,
    required this.lastTime,
    required this.chatId,
    this.lastMessage = '',
  });
  toJson() => {
        'chat_with': chatWith,
        'unread_messages': unreadMessages,
        'last_time': lastTime,
        'last_message': lastMessage,
        'chat_id': chatId,
      };
  factory Chat.fromJson(Map<String, dynamic> json) {
    final Chat chat = Chat(
      chatWith: json['chat_with'],
      lastTime: json['last_time'],
      chatId: json['chat_id'],
      unreadMessages: json['unread_messages'],
      lastMessage: json['last_message'],
    );
    return chat;
  }
}
