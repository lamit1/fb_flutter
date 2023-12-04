class Notification {
  final String? type;
  final String? objectId;
  final String? title;
  final String? notificationId;
  final String? created;
  final String? avatar;
  final String? group;
  final String? read;

  const Notification({
    required this.type,
    required this.objectId,
    required this.title,
    required this.notificationId,
    required this.created,
    required this.avatar,
    required this.group,
    required this.read,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      type: json['type'] as String,
      objectId: json['objectId'] as String,
      title: json['title'] as String,
      notificationId: json['same_friends'] as String,
      created: json['created'] as String,
      avatar: json['created'] as String,
      group: json['created'] as String,
      read: json['created'] as String,
    );
  }

  @override
  String toString() {
    return "$type, $objectId, $title, $notificationId, $created, $avatar, $group, $read";
  }
}
