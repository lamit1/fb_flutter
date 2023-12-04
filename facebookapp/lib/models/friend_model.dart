class Friend {
  final String? id;
  final String? username;
  final String? avatar;
  final String? sameFriends;
  final String? created;

  const Friend({
    required this.id,
    required this.username,
    required this.avatar,
    required this.sameFriends,
    required this.created,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String,
      sameFriends: json['same_friends'] as String,
      created: json['created'] as String,
    );
  }

  @override
  String toString() {
    return "$id, $username, $avatar, $sameFriends, $created";
  }
}
