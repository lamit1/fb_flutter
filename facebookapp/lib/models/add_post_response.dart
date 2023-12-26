class AddPostResponse {
  String? id;
  String? coins;

  AddPostResponse({
    this.id,
    this.coins,
  });

  factory AddPostResponse.fromJson(Map<String, dynamic> json) {
    return AddPostResponse(
      id: json['id'] as String?,
      coins: json['coins'] as String?,
    );
  }
}
