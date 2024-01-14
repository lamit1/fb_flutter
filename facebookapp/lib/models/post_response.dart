import 'package:fb_app/models/post_model.dart';

class PostResponse {
  List<Post> posts;
  String newItems;
  String lastId;

  PostResponse({
    required this.posts,
    required this.newItems,
    required this.lastId,
  });
  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      posts: json['post'] != null
          ? List<Post>.from(json['post'].map((x) => Post.fromJson(x)))
          : [],
      newItems: json['new_items'],
      lastId: json['last_id'],
    );
  }
}