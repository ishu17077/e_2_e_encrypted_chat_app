class Message {
  String? get id => _id;
  String recepient;
  String? _id;
  String chatId;
  DateTime time;
  String sender;
  String contents;
  bool isSeen;
  Message({
    required this.recepient,
    required this.time,
    required this.chatId,
    required this.sender,
    required this.contents,
    required this.isSeen,
  });
  toJson() => {
        'sender': sender,
        'recepient': recepient,
        'is_seen': isSeen,
        'contents': contents,
        'time': time,
        'chat_id': chatId,
      };
  factory Message.fromJson(Map<String, dynamic> json) {
    final Message message = Message(
      sender: json['sender'],
      recepient: json['receipient'],
      time: json['time'],
      contents: json['contents'],
      isSeen: json['is_seen'],
      chatId: json['chat_id'],
    );
    return message;
  }
}
