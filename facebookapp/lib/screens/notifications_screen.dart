import 'package:fb_app/models/notification_model.dart';
import 'package:fb_app/services/api/notification.dart';
import 'package:fb_app/widgets/notification_card.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  late List<NotificationModel> notification;

  @override
  void initState() {
    super.initState();
    notification = [];
    loadFriends();
  }

  void loadFriends() async {
    try {
      List<NotificationModel>? fetchedNotification = await NotificationAPI().getNotification(
        '0',
        '100',
      );
      if (fetchedNotification != null) {
        setState(() {
          notification = fetchedNotification;
        });
      }
    } catch (error) {
      Logger().d('Error loading Notifications: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return NotificationCard(notification: notification);
          }, childCount: notification.length),
        )
      ],
    );
  }
}
