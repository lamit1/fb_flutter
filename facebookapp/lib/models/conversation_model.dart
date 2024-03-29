import 'package:fb_app/models/user_model.dart';

class Conversation {
  final String? message;
  final String? messageId;
  final String? unread;
  final String? created;
  final User? sender;

  const Conversation({
    this.message,
    this.messageId,
    this.unread,
    this.created,
    this.sender,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      message: json['message'] as String?,
      messageId: json['messageId'] as String?,
      unread: json['unread'] as String?,
      created: json['created'] as String?,
      sender: User.fromJson(json['sender']),
    );
  }

  @override
  String toString() {
    return "$message, $messageId, $unread, $created, $sender";
  }
}