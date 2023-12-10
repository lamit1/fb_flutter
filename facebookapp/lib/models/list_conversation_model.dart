import 'package:fb_app/models/conversation_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/models/video_model.dart';

class ListConversations {
  final String? id;
  final User? user;
  final Conversation? conversation;

  const ListConversations({
    this.id,
    this.user,
    this.conversation,
  });

  factory ListConversations.fromJson(Map<String, dynamic> json) {
    return ListConversations(
      id: json['id'] as String?,
      user: User.fromJson(json['user']),
      conversation: Conversation.fromJson(json['conversation']),
    );
  }

  @override
  String toString() {
    return "$id, $user, $conversation";
  }
}