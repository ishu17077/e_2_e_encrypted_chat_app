class User {
  String get id => _id;
  final String name;
  final String username;
  final String email;
  final String? photoUrl;
  late String _id;
  final bool active;
  final DateTime lastSeen;

  User({
    required this.name,
    required this.email,
    required this.username,
    required this.photoUrl,
    required this.lastSeen,
    this.active = false,
  });

  toJSON() => {
    "name": name,
    "username": username,
    "email": email,
    "photo_url": photoUrl,
    "last_seen": lastSeen,
    "active": active,
  };

  factory User.fromJSON(Map<String, dynamic> map) {
    User user = User(
      username: map["username"],
      name: map["name"] ?? "Anonymous",
      email: map["email"],
      lastSeen: map["last_seen"] ?? DateTime(1997),
      photoUrl: map["photo_url"],
      active: map["active"] ?? false,
    );
    user._id = map["id"];

    return user;
  }
}
