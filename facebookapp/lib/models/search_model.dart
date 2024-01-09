class SearchPost {
  String? id;
  String? name;
  List<ImageSearch>? image;
  String? described;
  String? created;
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
      image: json['image'] != null ? (json['image'] as List).map((i) => ImageSearch.fromJson(i)).toList() : null,
      described: json['described'],
      created: json['created'],
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

class ImageSearch {
  String? id;
  String? url;

  ImageSearch({
    this.id,
    this.url,
  });

  factory ImageSearch.fromJson(Map<String, dynamic> json) {
    return ImageSearch(
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
