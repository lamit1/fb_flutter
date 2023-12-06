import 'package:fb_app/models/user_model.dart';

class Comment {
  final String content;
  final User poster;
  final String created;

  const Comment({
    required this.content,
    required this.poster,
    required this.created,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      content: json['content'] as String,
      created: json['created'] as String,
      poster: User.fromJson(json['poster']),
    );
  }

  @override
  String toString() {
    return "$content, $created, $poster";
  }
}