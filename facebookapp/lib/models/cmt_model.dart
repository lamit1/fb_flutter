import 'package:fb_app/models/user_model.dart';

class Cmt {
  final String content;
  final User poster;
  final String created;

  const Cmt({
    required this.content,
    required this.poster,
    required this.created,
  });

  factory Cmt.fromJson(Map<String, dynamic> json) {
    return Cmt(
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