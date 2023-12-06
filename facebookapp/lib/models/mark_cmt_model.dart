import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/cmt_model.dart';

class MarkComments {
  final String id;
  final String makeContent;
  final String typeOfMark;
  final User poster;
  final Comment comments;

  const MarkComments({
    required this.id,
    required this.makeContent,
    required this.typeOfMark,
    required this.poster,
    required this.comments,
  });

  factory MarkComments.fromJson(Map<String, dynamic> json) {
    return MarkComments(
      id: json['id'] as String,
      makeContent: json['makeContent'] as String,
      typeOfMark: json['typeOfMark'] as String,
      poster: User.fromJson(json['poster']),
      comments: Comment.fromJson(json['comments']),
    );
  }

  @override
  String toString() {
    return "$id, $makeContent, $typeOfMark, $poster, $comments";
  }
}