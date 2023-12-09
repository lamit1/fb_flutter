import 'package:fb_app/models/image_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/video_model.dart';
import 'package:fb_app/models/category_model.dart';

class PostDetail {
  final String id;
  final String name;
  final String created;
  final String described;
  final String modified;
  final String fake;
  final String trust;
  final String kudos;
  final String disappointed;
  final String isRated;
  final String isMarked;
  final List<Image> image;
  final List<Video> video;
  final User user;
  final List<Category> category;
  final String state;
  final String isBlocked;
  final String canEdit;
  final String banned;
  final String canMark;
  final String canRate;
  final String url;
  final List<String> message;
  final String feel;
  final String commentMark;
  final String isFelt;


  const PostDetail({
    required this.id,
    required this.commentMark,
    required this.feel,
    required this.isFelt,
    required this.name,
    required this.created,
    required this.described,
    required this.modified,
    required this.fake,
    required this.trust,
    required this.kudos,
    required this.disappointed,
    required this.isRated,
    required this.isMarked,
    required this.image,
    required this.video,
    required this.user,
    required this.category,
    required this.state,
    required this.isBlocked,
    required this.canEdit,
    required this.banned,
    required this.canMark,
    required this.canRate,
    required this.url,
    required this.message,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) {
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
    List<Category> categoryList = [];
    for (var item in json['video']) {
      Category category = Category.fromJson(item);
      categoryList.add(category);
    }
    return PostDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      created: json['created'] as String,
      described: json['described'] as String,
      modified: json['modified'] as String,
      fake: json['fake'] as String,
      trust: json['trust'] as String,
      kudos: json['kudos'] as String,
      disappointed: json['disappointed'] as String,
      isRated: json['is_rated'] as String,
      isMarked: json['is_marked'] as String,
      image: images,
      video: videos,
      user: User.fromJson(json['user']),
      category: categoryList,
      state: json['state'] as String,
      isBlocked: json['is_blocked'] as String,
      canEdit: json['can_edit'] as String,
      banned: json['banned'] as String,
      canMark: json['can_mark'] as String,
      canRate: json['can_rate'] as String,
      url: json['url'] as String,
      message: json['message'] as List<String>,
      commentMark: json['comment_mark'] as String,
      feel:  json['feel'] as String,
      isFelt: json['is_felt'] as String
    );
  }

  @override
  String toString() {
    return "$id, $name, $created, $described, $modified, $fake, $trust, $kudos, $disappointed, $isRated, $isMarked, $image, $video, $user, $category, $state, $isBlocked, $canEdit, $banned, $canMark, $canRate, $url, $message";
  }
}