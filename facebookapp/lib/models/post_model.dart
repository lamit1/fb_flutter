import 'package:fb_app/models/image_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/video_model.dart';
import 'package:logger/logger.dart';

class Post {
  final String? id;
  final String? name;
  final List<ImageNetwork>? image;
  final Video? video;
  final String? described;
  final String? created;
  final String? feel;
  String? commentMark;
  final String? isFelt;
  final String? isBlocked;
  final String? canEdit;
  final String? banned;
  final String? state;
  final User? user;

  Post({
    this.id,
    this.name,
    this.created,
    this.described,
    this.feel,
    this.commentMark,
    this.isFelt,
    this.isBlocked,
    this.canEdit,
    this.banned,
    this.state,
    this.image,
    this.video,
    this.user,
  });

  factory Post.fromJson(Map<String?, dynamic> json) {
    List<ImageNetwork> images = (json['image'] as List?)
            ?.map((item) => ImageNetwork.fromJson(item))
            .toList() ??
        [];
    Logger().d("Null image: $images");

    Video? video;
    if (json.containsKey('video') && json['video'] != null) {
      video = Video.fromJson(json['video']);
      Logger().d("NotNull video: $video");
    } else {
      Logger().d("Null video");
    }

    return Post(
      id: json['id'] as String?,
      name: json['name'] as String?,
      created: json['created'] as String?,
      described: json['described'] as String?,
      feel: json['feel'] as String?,
      commentMark: json['comment_mark'] as String?,
      isFelt: json['is_felt'] as String?,
      image: images,
      video: video,
      user: User.fromJson(json['author']),
      state: json['state'] as String?,
      isBlocked: json['is_blocked'] as String?,
      canEdit: json['can_edit'] as String?,
      banned: json['banned'] as String?,
    );
  }

  @override
  String toString() {
    return "$id, $name, $created, $described, $feel, $commentMark, $isFelt, $image, $video, $user, $state, $isBlocked, $canEdit, $banned";
  }
}
