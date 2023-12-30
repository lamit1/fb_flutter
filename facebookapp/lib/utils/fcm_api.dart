import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/storage.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  //TODO: Implement when click on notification

  //TODO: Go to post detail screen when friend add post or something relate to post

  //TODO: Go to personal profile screen

  //TODO: Go to accept friend screen

  print("Handling a background message: ${message.messageId}");
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

    // Handler for background message
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    // Handler for message when the app is opened from a terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Received a message that opened the app: ${message.messageId}");
      // Here you can navigate to a specific screen based on the message
    });
  }
}
