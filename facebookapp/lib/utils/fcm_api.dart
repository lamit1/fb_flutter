import 'package:fb_app/models/notification_model.dart';
import 'package:fb_app/screens/profile_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/home_screen.dart';
import '../services/storage.dart';
enum NotificationType {
  FriendRequest,
  FriendAccepted,
  PostAdded,
  PostUpdated,
  PostFelt,
  PostMarked,
  MarkCommented,
  VideoAdded,
  PostCommented,
}
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print(123123123);
}

const Map<NotificationType, int> _notificationTypeValues = {
  NotificationType.FriendRequest: 1,
  NotificationType.FriendAccepted: 2,
  NotificationType.PostAdded: 3,
  NotificationType.PostUpdated: 4,
  NotificationType.PostFelt: 5,
  NotificationType.PostMarked: 6,
  NotificationType.MarkCommented: 7,
  NotificationType.VideoAdded: 8,
  NotificationType.PostCommented: 9,
};

NotificationType? valueToNotificationType(int value) {
  try {
    return _notificationTypeValues.keys
        .firstWhere((k) => _notificationTypeValues[k] == value);
  } catch (e) {
    // If the value is not found in the map, return null
    return null;
  }
}

class FirebaseMessage {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    String? devToken = await messaging.getToken();
    await messaging.requestPermission();
    if (devToken != null) {
      Storage().saveDevToken(devToken);
      print("Firebase Messaging Token: $devToken");
    } else {
      throw Exception("DevToken was null");
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Handling a foreground message: ${message.messageId}");
      // Here you can show a notification manually if needed
    });
    // Handler for message when the app is opened from a terminated state


    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  }
}

navigateBasedOnMessage(Map<String, dynamic> messageData) {
  print("Attempting to navigate based on message data: $messageData");
  try {
    NotificationModel notification = NotificationModel.fromJson(messageData);
    NotificationType? notificationType = valueToNotificationType(int.tryParse(notification.type ?? '') ?? -1);

    print("Parsed notification type: $notificationType");
    if (notificationType == null) {
      print("Unknown notification type.");
      return;
    }

    navigatorKey.currentState?.push(getRouteBasedOnNotificationType(notificationType, notification));
  } catch (e, stackTrace) {
    print("Error while trying to navigate: $e");
    print("Stack Trace: $stackTrace");
  }
}


MaterialPageRoute getRouteBasedOnNotificationType(NotificationType notificationType, NotificationModel notification) {
  print("123 $notificationType");
  switch (notificationType) {
    case NotificationType.FriendRequest:
    case NotificationType.FriendAccepted:
    // If these two notification types lead to the same screen, combine them
      return MaterialPageRoute(builder: (context) => ProfileScreen(id: notification.user!.id!, type: '2'));

    case NotificationType.PostAdded:
    case NotificationType.PostUpdated:
    case NotificationType.PostFelt:
    case NotificationType.PostMarked:
    case NotificationType.PostCommented:
    // TODO: Navigate to the post detail screen
    //   return MaterialPageRoute(builder: (context) => PostDetailScreen(postId: notification.post!.id!));

    case NotificationType.MarkCommented:
    // TODO: Navigate to the mark commented notification screen
    //   return MaterialPageRoute(builder: (context) => MarkCommentedScreen(commentId: notification.mark!.id!));
    case NotificationType.VideoAdded:
    // TODO: Navigate to the video added screen
    //   return MaterialPageRoute(builder: (context) => VideoScreen(videoId: notification.video!.id!));
    default:
    // Handle any other case or add an error log
      return MaterialPageRoute(builder: (context) => const HomeScreen());
      break;
  }
}

