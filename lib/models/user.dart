import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? get id => _id;
  String? username;
  String? photoUrl;
  String? emailAddress;
  String? _id;
  DateTime lastseen;
  String? publicKeyJwb;

  User({
    required this.emailAddress,
    required this.username,
    required this.photoUrl,
    required this.lastseen,
    required this.publicKeyJwb,
  });
  toJson() => {
        'email_address': emailAddress,
        'username': username,
        'photo_url': photoUrl,
        'last_seen': lastseen,
        'public_key_jwb': publicKeyJwb!,
      };
  factory User.fromJson(Map<String, dynamic> userMap) {
    final User user = User(
      emailAddress: userMap['email_address'],
      username: userMap['username'],
      publicKeyJwb: userMap['public_key_jwb'] ?? '',
      photoUrl: userMap['photo_url'],
      lastseen: (userMap['last_seen'] as Timestamp).toDate(),
    );
    return user;
  }
}
