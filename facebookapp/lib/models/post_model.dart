import 'package:fb_app/models/image_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/video_model.dart';
import 'package:fb_app/models/category_model.dart';

class Post {
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
  final Image image;
  final Video video;
  final User user;
  final Category category;
  final String state;
  final String isBlocked;
  final String canEdit;
  final String banned;
  final String canMark;
  final String canRate;
  final String url;
  final List<String> message;

  const Post({
    required this.id,
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

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      name: json['name'] as String,
      created: json['created'] as String,
      described: json['described'] as String,
      modified: json['modified'] as String,
      fake: json['fake'] as String,
      trust: json['trust'] as String,
      kudos: json['kudos'] as String,
      disappointed: json['disappointed'] as String,
      isRated: json['isRated'] as String,
      isMarked: json['isMarked'] as String,
      image: json['image'] as Image,
      video: json['video'] as Video,
      user: json['user'] as User,
      category: json['category'] as Category,
      state: json['state'] as String,
      isBlocked: json['isBlocked'] as String,
      canEdit: json['canEdit'] as String,
      banned: json['banned'] as String,
      canMark: json['canMark'] as String,
      canRate: json['canRate'] as String,
      url: json['url'] as String,
      message: json['message'] as List<String>,
    );
  }

  @override
  String toString() {
    return "$id, $name, $created, $described, $modified, $fake, $trust, $kudos, $disappointed, $isRated, $isMarked, $image, $video, $user, $category, $state, $isBlocked, $canEdit, $banned, $canMark, $canRate, $url, $message";
  }
}