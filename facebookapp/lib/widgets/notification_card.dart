import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final List<NotificationModel> notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = widget.notification;

    return SingleChildScrollView(
      child: Column(
        children: notifications
            .map(
              (notification) => Card(
            shadowColor: Colors.grey,
            child: InkWell(
              onTap: () {
                // Handle the onTap event as needed
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          // Avatar Image
                          CircleAvatar(
                            backgroundImage: NetworkImage(notification.user!.avatar!),
                            radius: 30.0,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: notification.read == '0'
                                    ? Colors.white  // Unread state
                                    : Colors.grey[200],  // Read state
                              ),
                              child: const Icon(
                                Icons.thumb_up,
                                color: Palette.facebookBlue,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${notification.user!.name} has liked your post",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: notification.read == '0'
                                  ? Colors.black  // Unread state
                                  : Colors.grey,  // Read state
                            ),
                          ),
                          Text(
                            "5 mins ago",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: notification.read == '0'
                                  ? Colors.black  // Unread state
                                  : Colors.grey,  // Read state
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Handle the onPressed event as needed
                              },
                              splashRadius: 20.0,
                              icon: const Icon(
                                Icons.more_vert,
                                color: Palette.facebookBlue,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
