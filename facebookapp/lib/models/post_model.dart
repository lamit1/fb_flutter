import 'package:fb_app/models/image_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/video_model.dart';

class Post {
  final String id;
  final String name;
  final List<Image> image;
  final List<Video> video;
  final String described;
  final String created;
  final String feel;
  final String commentMark;
  final String isFelt;
  final String isBlocked;
  final String canEdit;
  final String banned;
  final String status;
  final User user;

  const Post({
    required this.id,
    required this.name,
    required this.created,
    required this.described,
    required this.feel,
    required this.commentMark,
    required this.isFelt,
    required this.isBlocked,
    required this.canEdit,
    required this.banned,
    required this.status,
    required this.image,
    required this.video,
    required this.user,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Image> images = [];
    for (var item in json['image']) {
      Image image = Image.fromJson(item);
      images.add(image);
    }
    List<Video> videos = [];
    for (var item in json['video']) {
      Video video = Video.fromJson(item);
      videos.add(video);
    }
    return Post(
      id: json['id'] as String,
      name: json['name'] as String,
      created: json['created'] as String,
      described: json['described'] as String,
      feel: json['feel'] as String,
      commentMark: json['comment_mark'] as String,
      isFelt: json['is_felt'] as String,
      image: images,
      video: videos,
      user: User.fromJson(json['user']),
      status: json['status'] as String,
      isBlocked: json['is_blocked'] as String,
      canEdit: json['can_edit'] as String,
      banned: json['banned'] as String,
    );
  }

  @override
  String toString() {
    return "$id, $name, $created, $described, $feel, $commentMark, $isFelt, $image, $video, $user, $status, $isBlocked, $canEdit, $banned";
  }
}