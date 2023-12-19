import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/cmt_model.dart';

class MarkComments {
  final String? id;
  final String? markContent;
  final String? typeOfMark;
  final User? poster;
  final List<Comment>? comments;
  final String? created;


  const MarkComments({
    this.id,
    this.markContent,
    this.typeOfMark,
    this.poster,
    this.comments,
    this.created
  });

  factory MarkComments.fromJson(Map<String, dynamic> json) {
    List<Comment> commentList = (json['comments'] as List?)
        ?.map((item) => Comment.fromJson(item))
        .toList() ?? [];
    return MarkComments(
      id: json['id'] as String?,
      markContent: json['mark_content'] as String?,
      typeOfMark: json['type_of_mark'] as String?,
      created: json['created'] as String?,
      poster: User.fromJson(json['poster']),
      comments: commentList,
    );
  }

  @override
  String toString() {
    return "$id, $markContent, $typeOfMark, $poster, $comments";
  }
}