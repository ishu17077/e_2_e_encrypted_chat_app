import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? get id => _id;
  String? username;
  String? photoUrl;
  String? emailAddress;
  String? _id;
  DateTime lastseen;

  User({
    required this.emailAddress,
    required this.username,
    required this.photoUrl,
    required this.lastseen,
  });
  toJson() => {
        'email_address': emailAddress,
        'username': username,
        'photo_url': photoUrl,
        'last_seen': lastseen,
      };
  factory User.fromJson(Map<String, dynamic> json) {
    final User user = User(
      emailAddress: json['email_address'],
      username: json['username'],
      photoUrl: json['photo_url'],
      lastseen: (json['last_seen'] as Timestamp).toDate() ,
    );
    return user;
  }
}
