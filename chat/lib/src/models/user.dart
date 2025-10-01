import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? get id => _id;
  final String name;
  final String username;
  final String email;
  //TODO: Impl of publickey
  // final String publicKey;
  final String? photoUrl;
  String? _id;
  bool active;
  DateTime lastSeen;

  User({
    required this.name,
    required this.email,
    required this.username,

    required this.lastSeen,
    // required this.publicKey,
    this.active = false,
    this.photoUrl,
    String? id,
  }) {
    this._id ??= id;
  }

  Map<String, dynamic> toJSON() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "photo_url": photoUrl,
    // "public_k"
    "last_seen": lastSeen,
    "active": active,
  };

  factory User.fromJSON(Map<String, dynamic> map) {
    User user = User(
      username: map["username"]!,
      name: map["name"] ?? "Anonymous",
      email: map["email"]!,
      lastSeen: ((map["last_seen"] ?? Timestamp.now()) as Timestamp).toDate(),
      photoUrl: map["photo_url"],
      active: map["active"] ?? false,
    );
    user._id = map["id"];

    return user;
  }
}
