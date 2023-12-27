class EditProfileResponse {
  String? avatar;
  String? coverImage;
  String? link;
  String? city;
  String? country;

  EditProfileResponse({
    this.avatar,
    this.coverImage,
    this.link,
    this.city,
    this.country,
  });
  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return EditProfileResponse(
      avatar: json['avatar'],
      coverImage: json['cover_image'],
      link: json['link'],
      city: json['city'],
      country: json['country'],
    );
  }
}