import 'package:e_2_e_encrypted_chat_app/models/message_store.dart';

class ChatStore {
  int? get id => _id;
  int? _id;
  String belongsToEmail;
  String? name;
  String photoUrl;

  ChatStore({
    required this.belongsToEmail,
    required this.photoUrl,
    this.name,
  });
  ChatStore.withId(
    this._id, {
    required this.belongsToEmail,
    required this.name,
    required this.photoUrl,
  });

  toJson() => {
        'belongs_to_email': belongsToEmail,
        'photo_url': photoUrl,
        'name': name,
      };

  factory ChatStore.fromJson(Map<String, dynamic> chatStoreMap) {
    final ChatStore chatStore = ChatStore.withId(
      chatStoreMap['id'],
      belongsToEmail: chatStoreMap['belongs_to_email'],
      photoUrl: chatStoreMap['photo_url'],
      name: chatStoreMap['name'],
    );
    return chatStore;
  }
}
