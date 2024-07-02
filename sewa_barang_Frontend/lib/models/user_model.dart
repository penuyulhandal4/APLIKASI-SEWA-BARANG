class User {
  final int id;
  final String username;
  final String fullname;
  final String contact;
  final String? gender;
  final String address;
  final String photoUrl;
  final DateTime createAt;

  User({
    required this.id,
    required this.username,
    required this.fullname,
    required this.contact,
    this.gender,
    required this.address,
    required this.photoUrl,
    required this.createAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullname: json['fullname'],
      contact: json['contact'],
      gender: json['gender'],
      address: json['address'],
      photoUrl: json['photo_url'],
      createAt: DateTime.parse(json['create_at']),
    );
  }
}
