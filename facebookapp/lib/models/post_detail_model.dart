import 'package:fb_app/models/image_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/video_model.dart';
import 'package:fb_app/models/category_model.dart';
import 'package:logger/logger.dart';

class PostDetail {
  final String? id;
  final String? name;
  final String? created;
  final String? described;
  final String? modified;
  final String? fake;
  final String? trust;
   String? kudos;
   String? disappointed;
  final String? isRated;
  String? isMarked;
  final List<ImageNetwork>? image;
  final Video? video;
  final User? user;
  final Category? category;
  final String? state;
  final String? isBlocked;
  String? isFelt;
  final String? canEdit;
  final String? banned;
  final String? canMark;
  final String? canRate;
  final String? url;
  final List<String>? message;

  PostDetail({
    this.id,
    this.name,
    this.created,
    this.described,
    this.modified,
    this.fake,
    this.trust,
    this.kudos,
    this.disappointed,
    this.isRated,
    this.isMarked,
    this.isFelt,
    this.image,
    this.video,
    this.user,
    this.category,
    this.state,
    this.isBlocked,
    this.canEdit,
    this.banned,
    this.canMark,
    this.canRate,
    this.url,
    this.message,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    List<ImageNetwork> images = (json['image'] as List?)
        ?.map((item) => ImageNetwork.fromJson(item))
        .toList() ??
        [];
    Video? video;
    if (json.containsKey('video') && json['video'] != null) {
      video = Video.fromJson(json['video']);
      Logger().d("NotNull video: $video");
    } else {
      Logger().d("Null video");
    }
    return PostDetail(
      id: json['id'] as String?,
      name: json['name'] as String?,
      created: json['created'] as String?,
      described: json['described'] as String?,
      modified: json['modified'] as String?,
      fake: json['fake'] as String?,
      trust: json['trust'] as String?,
      kudos: json['kudos'] as String?,
      disappointed: json['disappointed'] as String?,
      isRated: json['is_rated'] as String?,
      isMarked: json['is_marked'] as String?,
      image: images,
      video: video,
      user: User.fromJson(json['author']),
      category: Category.fromJson(json['category']),
      isFelt: json['is_felt'] as String,
      state: json['state'] as String?,
      isBlocked: json['is_blocked'] as String?,
      canEdit: json['can_edit'] as String?,
      banned: json['banned'] as String?,
      canMark: json['can_mark'] as String?,
      canRate: json['can_rate'] as String?,
      url: json['url'] as String?,
      message: json['message'] as List<String>?,
    );
  }

  @override
  String toString() {
    return "$id, $name, $created, $described, $modified, $fake, $trust, $kudos, $disappointed, $isRated, $isMarked, $image, $video, $user, $category, $state, $isBlocked, $canEdit, $banned, $canMark, $canRate, $url, $message";
  }
}