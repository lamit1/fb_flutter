import 'package:fb_app/models/user_model.dart';

class Notification {
  final String? type;
  final String? objectId;
  final String? title;
  final String? notificationId;
  final String? created;
  final String? avatar;
  final String? group;
  final String? read;
  final User? user;
  final String? post;
  final String? mark;
  final String? feel;

  const Notification({
    this.type,
    this.objectId,
    this.title,
    this.notificationId,
    this.created,
    this.avatar,
    this.group,
    this.read,
    this.user,
    this.post,
    this.mark,
    this.feel,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      type: json['type'] as String?,
      objectId: json['object_id'] as String?,
      title: json['title'] as String?,
      notificationId: json['notification_id'] as String?,
      created: json['created'] as String?,
      avatar: json['avatar'] as String?,
      group: json['group'] as String?,
      read: json['read'] as String?,
      user: User.fromJson(json['user']),
      post: json['post'] as String?,
      mark: json['mark'] as String?,
      feel: json['feel'] as String?,
    );
  }

  @override
  String toString() {
    return "$type, $objectId, $title, $notificationId, $created, $avatar, $group, $read, $user, $post, $mark, $feel";
  }
}
