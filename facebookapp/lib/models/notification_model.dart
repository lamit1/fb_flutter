import 'package:intl/intl.dart';

class NotificationModel {
  String? type;
  String? objectId;
  String? title;
  String? notificationId;
  String? created;
  String? avatar;
  String? group;
  String? read;
  User? user;
  Post? post;
  Mark? mark;
  Feel? feel;

  NotificationModel({
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
  NotificationModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    objectId = json['object_id'];
    title = json['title'];
    notificationId = json['notification_id'];
    created = json['created'];
    avatar = json['avatar'];
    group = json['group']; // 0: notification; 1: action
    read = json['read'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    post = json['post'] != null ? Post.fromJson(json['post']) : null;
    mark = json['mark'] != null ? Mark.fromJson(json['mark']) : null;
    feel = json['feel'] != null ? Feel.fromJson(json['feel']) : null; // 0: fake; 1: trust
  }
}

class Feel {
  String? feelId;
  String? type;

  Feel({
    this.feelId,
    this.type,
  });
  Feel.fromJson(Map<String, dynamic> json) {
    feelId = json['feelId'];
    type = json['type'];
  }
}

class Post {
  String? id;
  String? described;
  String? status;

  Post({
    this.id,
    this.described,
    this.status,
  });
  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    described = json['described'];
    status = json['status'];
  }
}

enum Title {
  Notification
}

class User {
  String? id;
  String? username;
  String? avatar;

  User({
    this.id,
    this.username,
    this.avatar,
  });
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatar = json['avatar'];
  }
}
class Mark {
  String? markId;
  String? typeOfMark;
  String? markContent;

  Mark({
    this.markId,
    this.typeOfMark,
    this.markContent,
  });
  Mark.fromJson(Map<String, dynamic> json) {
    markId = json['mark_id'];
    typeOfMark = json['type_of_mark'];
    markContent = json['mark_content'];
  }
}