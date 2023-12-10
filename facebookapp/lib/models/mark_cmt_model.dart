import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/cmt_model.dart';

class MarkComments {
  final String? id;
  final String? makeContent;
  final String? typeOfMark;
  final User? poster;
  final List<Comment>? comments;

  const MarkComments({
    this.id,
    this.makeContent,
    this.typeOfMark,
    this.poster,
    this.comments,
  });

  factory MarkComments.fromJson(Map<String, dynamic> json) {
    List<Comment> commentList = (json['comments'] as List?)
        ?.map((item) => Comment.fromJson(item))
        .toList() ??
        [];
    return MarkComments(
      id: json['id'] as String?,
      makeContent: json['make_content'] as String?,
      typeOfMark: json['type_of_mark'] as String?,
      poster: User.fromJson(json['poster']),
      comments: commentList,
    );
  }

  @override
  String toString() {
    return "$id, $makeContent, $typeOfMark, $poster, $comments";
  }
}