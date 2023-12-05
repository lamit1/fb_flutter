import 'package:fb_app/models/user_model.dart';

class Post {
  final User user;
  final String caption;
  final String timeAgo;
  final List<String>? imageUrls;
  final int likes;
  final int comments;
  final int shares;

  const Post({
    required this.user,
    required this.caption,
    required this.timeAgo,
    this.imageUrls,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}