class User {
  String get id => _id;
  final String name;
  final String email;
  final String photoUrl;
  late String _id;
  final bool active;
  final DateTime lastSeen;

  User({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.lastSeen,
    this.active = false,
  });

  toJSON() => {
    "name": name,
    "email": email,
    "photo_url": photoUrl,
    "last_seen": lastSeen,
    "active": active,
  };

  factory User.fromJSON(Map<String, dynamic> map) {
    User user = User(
      name: map["name"],
      email: map["email"],
      lastSeen: map["last_seen"],
      photoUrl: map["photo_url"],
      active: map["active"],
    );
    user._id = map["id"];

    return user;
  }
}
