class SuggestedFriend {
  final String? userId;
  final String? username;
  final String? avatar;
  final String? sameFriends;

  const SuggestedFriend({
    this.userId,
    required this.username,
    required this.avatar,
    this.sameFriends,
  });

  factory SuggestedFriend.fromJson(Map<String, dynamic> json) {
    return SuggestedFriend(
      userId: json['user_id'] as String?,
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
      sameFriends: json['same_friends'] as String?,
    );
  }

  @override
  String toString() {
    return "$userId, $username, $avatar, $sameFriends";
  }
}
