class SearchUser {
  String? id;
  String? username;
  String? avatar;
  DateTime? created;
  String? sameFriends;

  SearchUser({
    this.id,
    this.username,
    this.avatar,
    this.created,
    this.sameFriends,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      id: json['id'] as String?,
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      sameFriends: json['same_friends'] as String?,
    );
  }

}
