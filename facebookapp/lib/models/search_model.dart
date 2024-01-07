class SearchPost {
  String? id;
  String? name;
  List<Image>? image;
  String? described;
  DateTime? created;
  String? feel;
  String? markComment;
  String? isFelt;
  String? state;
  Author? author;
  Video? video;

  SearchPost({
    this.id,
    this.name,
    this.image,
    this.described,
    this.created,
    this.feel,
    this.markComment,
    this.isFelt,
    this.state,
    this.author,
    this.video,
  });

  factory SearchPost.fromJson(Map<String, dynamic> json) {
    return SearchPost(
      id: json['id'],
      name: json['name'],
      image: json['image'] != null ? (json['image'] as List).map((i) => Image.fromJson(i)).toList() : null,
      described: json['described'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      feel: json['feel'],
      markComment: json['mark_comment'],
      isFelt: json['is_felt'],
      state: json['state'],
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      video: json['video'] != null ? Video.fromJson(json['video']) : null,
    );
  }

  static List<SearchPost> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SearchPost.fromJson(json)).toList();
  }
}

class Author {
  String? id;
  String? name;
  String? avatar;

  Author({
    this.id,
    this.name,
    this.avatar,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }


}

class Image {
  String? id;
  String? url;

  Image({
    this.id,
    this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      url: json['url'],
    );
  }
}

class Video {
  String? url;

  Video({
    this.url,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'],
    );
  }
}
