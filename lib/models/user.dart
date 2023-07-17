class User {
  String? get id => _id;
  String username;
  String photoUrl;
  String emailAddress;
  String? _id;
  bool active;
  List<String>? talksWithEmails;
  DateTime lastseen;

  User({
    required this.emailAddress,
    required this.username,
    required this.photoUrl,
    required this.active,
    required this.lastseen,
    this.talksWithEmails,
  });
  toJson() => {
        'email_address': emailAddress,
        'username': username,
        'photo_url': photoUrl,
        'active': active,
        'last_seen': lastseen,
        'talks_with_emails': talksWithEmails ?? ['Nobody'],
      };
  factory User.fromJson(Map<String, dynamic> json) {
    final User user = User(
      emailAddress: json['email_address'],
      username: json['username'],
      photoUrl: json['photo_url'],
      active: json['active'],
      lastseen: json['last_seen'],
      talksWithEmails: json['talks_with_emails'],
    );
    return user;
  }
}
