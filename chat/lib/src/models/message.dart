class Message {
  String get id => _id;

  final String from;
  final String to;
  final String contents;
  final DateTime time;
  late String _id;

  Message({
    required this.from,
    required this.to,
    required this.contents,
    required this.time,
  });

  toJSON() => {"from": from, "to": to, "contents": contents, "time": time};

  factory Message.fromJSON(Map<String, dynamic> map) {
    Message message = Message(
      from: map["from"]!,
      to: map["to"]!,
      contents: map["contents"],
      time: map["time"],
    );
    message._id = map["id"];

    return message;
  }
}
