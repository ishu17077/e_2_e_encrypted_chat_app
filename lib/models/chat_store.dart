import 'package:e_2_e_encrypted_chat_app/models/message_store.dart';

class ChatStore {
  int? get id => _id;
  int? _id;
  String belongsToEmail;
  String? name;
  String? photoUrl;
  String? userIdFromServer;
  MessageStore? mostRecentMessage;
  // String? publicKeyJwk;

  ChatStore({
    required this.belongsToEmail,
    required this.photoUrl,
    required this.mostRecentMessage,

    // required this.publicKeyJwk,
    this.name,
  });
  ChatStore.withId(
    this._id, {
    required this.belongsToEmail,
    this.name,
    required this.photoUrl,
    required this.mostRecentMessage,
    // required this.publicKeyJwk,
  });
  ChatStore.withUserServerIdSetter({
    required this.userIdFromServer,
    required this.belongsToEmail,
    required this.mostRecentMessage,
    required this.name,
    required this.photoUrl,
  });

  toJson() => {
        'belongs_to_email': belongsToEmail,
        'photo_url': photoUrl,
        'user_id_from_server': userIdFromServer,
        // 'public_key_jwb': publicKeyJwk,
        'most_recent_message_contents': mostRecentMessage?.contents ?? '',
        'most_recent_message_time':
            mostRecentMessage?.time.toString() ?? DateTime.now().toString(),
        'most_recent_message_is_seen':
            mostRecentMessage?.isSeen.toString() ?? 'false',
        'most_recent_message_sender_email':
            mostRecentMessage?.senderEmail ?? '',
        'most_recent_message_recipient_email':
            mostRecentMessage?.recipientEmail ?? '',
        'name': name,
      };

  factory ChatStore.fromJson(Map<String, dynamic> chatStoreMap) {
    final ChatStore chatStore = ChatStore.withId(
      chatStoreMap['id'],
      mostRecentMessage: MessageStore(
        chatId: chatStoreMap['id'],
        contents: chatStoreMap['most_recent_message_contents'] ?? '',
        isSeen: chatStoreMap['most_recent_message_is_seen'] == 'true'
            ? true
            : false,
        senderEmail: chatStoreMap['most_recent_message_sender_email'],
        recipientEmail: chatStoreMap['most_recent_message_recipient_email'],
        time: DateTime.parse(chatStoreMap['most_recent_message_time']),
      ),
      belongsToEmail: chatStoreMap['belongs_to_email'],
      photoUrl: chatStoreMap['photo_url'],
      name: chatStoreMap['name'],
      // publicKeyJwk: chatStoreMap['public_key_jwb'],
    );
    return chatStore;
    //! Map.castFrom(... as Map); see if it works instead of most_recent_message_.....
  }
}
