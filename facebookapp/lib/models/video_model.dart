import 'package:fb_app/models/user_model.dart';

class Video {
  final User user;
  final String caption;
  final String timeAgo;
  final String? videoUrl;
  final int likes;
  final int comments;
  final int shares;

  const Video({
    required this.user,
    required this.caption,
    required this.timeAgo,
    required this.videoUrl,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}
