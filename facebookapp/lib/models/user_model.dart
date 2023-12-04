
class User {
  final String? id;
  final String? username;
  final String? email;
  final String? password;
  final String? imageUrl;
  final String? coins;
  final String? active;

  const User({
    this.email,
    this.password,
    this.id,
    this.username,
    this.imageUrl,
    this.coins,
    this.active
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      imageUrl: json['imageUrl'] as String?,
      coins: json['coins'] as String?,
      active: json['active'] as String?,
    );
  }

  static const empty = User();

  @override
  String toString() {
    return "$id, $username, $email, $coins, $active";
  }
}