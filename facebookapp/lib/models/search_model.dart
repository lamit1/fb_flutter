import 'package:fb_app/models/image_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/video_model.dart';

class Search {
  final String id;
  final String name;
  final String image;
  final Video? video;
  final String described;
  final String feel;
  final String commentMark;
  final String isFelt;
  final User user;

  const Search({
    required this.id,
    required this.name,
    required this.described,
    required this.feel,
    required this.commentMark,
    required this.isFelt,
    required this.image,
    required this.video,
    required this.user,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      id: json['id'] as String,
      name: json['name'] as String,
      described: json['described'] as String,
      feel: json['feel'] as String,
      commentMark: json['comment_mark'] as String,
      isFelt: json['is_felt'] as String,
      image: json['image'] as String,
      video: Video.fromJson(json['video']),
      user: User.fromJson(json['user']),
    );
  }

  @override
  String toString() {
    return "$id, $name, $described, $feel, $commentMark, $isFelt, $image, $video, $user";
  }
}