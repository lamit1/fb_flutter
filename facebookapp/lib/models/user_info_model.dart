
class UserInfo {
  final String? id;
  final String? username;
  final String? created;
  final String? description;
  final String? avatar;
  final String? coverAvatar;
  final String? link;
  final String? address;
  final String? city;
  final String? country;
  final String? listing;
  final String? isFriend;
  final String? online;

  const UserInfo({
    this.id,
    this.username,
    this.created,
    this.description,
    this.avatar,
    this.coverAvatar,
    this.link,
    this.address,
    this.city,
    this.country,
    this.listing,
    this.isFriend,
    this.online,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String?,
      username: json['username'] as String?,
      created: json['created'] as String?,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      coverAvatar: json['cover_avatar'] as String?,
      link: json['link'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      listing: json['listing'] as String?,
      isFriend: json['is_friend'] as String?,
      online: json['online'] as String?,
    );
  }

  static const empty = UserInfo();

  @override
  String toString() {
    return "$id, $username, $created, $coverAvatar, $link, $address, $city, $country, $listing, $isFriend, $online";
  }
}