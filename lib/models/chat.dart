class Chat {
  String? get id => _id;
  String? _id;
  String chatWith;
  int unreadMessages;
  String? lastMessage;
  Chat({
    required this.chatWith,
    required this.unreadMessages,
    this.lastMessage = '',
  });
  toJson() => {
        'chat_with': chatWith,
        'unread_messages': unreadMessages,
        'last_message': lastMessage,
      };
  factory Chat.fromJson(Map<String, dynamic> json) {
    final Chat chat = Chat(
      chatWith: json['chat_with'],
      unreadMessages: json['unread_messages'],
      lastMessage: json['last_message'],
    );
    return chat;
  }
}
