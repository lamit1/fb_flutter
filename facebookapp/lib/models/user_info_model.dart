
class UserInfo {
   String? id;
   String? username;
   String? created;
   String? description;
   String? avatar;
   String? coverAvatar;
   String? link;
   String? address;
   String? city;
   String? country;
   String? listing;
   String? isFriend;
   String? online;
   String? coins;
  
   UserInfo({
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
     this.coins
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String?,
      username: json['username'] as String?,
      created: json['created'] as String?,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      coverAvatar: json['cover_image'] as String?,
      link: json['link'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      listing: json['listing'] as String?,
      isFriend: json['is_friend'] as String?,
      online: json['online'] as String?,
      coins: json['coins'] as String?
    );
  }

  @override
  String toString() {
    return "$id, $username, $created, $coverAvatar, $link, $address, $city, $country, $listing, $isFriend, $online";
  }
}