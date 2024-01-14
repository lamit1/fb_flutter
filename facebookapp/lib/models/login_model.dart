class LoginResponse {
  String? id;
  String? username;
  String? token;
  String? avatar;
  String? active;
  String? coins;

  LoginResponse({
    this.id,
    this.username,
    this.token,
    this.avatar,
    this.active,
    this.coins,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      username: json['username'],
      token: json['token'],
      avatar: json['avatar'],
      active: json['active'],
      coins: json['coins'],
    );
  }
}
