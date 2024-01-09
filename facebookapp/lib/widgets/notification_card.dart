import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/notification_model.dart';
import 'package:fb_app/services/api/friend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../screens/post_detail_screen.dart';
import '../screens/profile_screen.dart';

class NotificationCard extends StatefulWidget {
  final List<NotificationModel> notification;
  final Function()? reloadList;

  const NotificationCard({Key? key, required this.notification, required this.reloadList})
      : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  void showTimedAlertDialog(String title, String content, Duration duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(duration, () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  void accept(userId, isAccept) async {
    try {
      String? resp = await FriendAPI().setAcceptFriend(
        userId,
        isAccept,
      );
      if (resp != null) {
        Logger().d('Accept Friend');
        widget.reloadList!();
        showTimedAlertDialog('Success', 'Friend request accepted successfully.', const Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Accept: $error');
      showTimedAlertDialog('Error', 'Failed to accept friend request.', const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = widget.notification;

    return SingleChildScrollView(
      child: Column(
        children: notifications.map(
              (notification) {
            return Card(
              color: notification.read == '0' ? Colors.blue[100] : Colors.white,
              shadowColor: Colors.grey,
              child: InkWell(
                onTap: () {
                  if (notification.type == '1' || notification.type == '2') {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(id: notification.user!.id!, type:'2')));
                  } else if (notification.type == '3'
                      || notification.type == '4'
                      || notification.type == '5'
                      || notification.type == '6'
                      || notification.type == '7'
                      || notification.type == '8'
                      || notification.type == '9'
                  ) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(postId: notification.post!.id!,),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  notification.user?.avatar ?? ''),
                              radius: 30.0,
                            ),
                            if (notification.type == '5')
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    (notification.feel?.type == '0'
                                        ? Icons.sentiment_very_satisfied_sharp
                                        : Icons.sentiment_dissatisfied_rounded),
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                buildNotificationText(notification),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                buildTimeText(notification),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              if (notification.type == '1')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    FilledButton(
                                      onPressed: () {
                                        accept(notification.user?.id,'1');
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Palette.facebookBlue),
                                        padding:
                                        MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 16.0)),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.check),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text("Accept"),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    FilledButton(
                                        onPressed: () {
                                          accept(notification.user?.id,'0');
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey),
                                          padding:
                                          MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0)),
                                          foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                          overlayColor:
                                          MaterialStateProperty.resolveWith<
                                              Color>(
                                                (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return Colors.grey;
                                              }
                                              return Palette.scaffold;
                                            },
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.cancel),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text("Delete"),
                                          ],
                                        ))
                                  ],
                                ),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       IconButton(
                        //         onPressed: () {
                        //           // Handle the onPressed event as needed
                        //         },
                        //         splashRadius: 20.0,
                        //         icon: const Icon(
                        //           Icons.more_vert,
                        //           color: Palette.facebookBlue,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  String buildTimeText(NotificationModel notification) {
    // Tính khoảng thời gian
    String? timeAgo = formatDuration(notification.created ?? '');

    return timeAgo ?? 'Unknown time ago';
  }

  String? formatDuration(String created) {
    if (created == null) {
      return null;
    }
    DateTime createdAt = DateTime.parse(created);
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1
          ? 's'
          : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes > 1
          ? 's'
          : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String buildNotificationText(NotificationModel notification) {
    switch (notification.type) {
      case '1':
        return "${notification.user?.username ??
            'Unknown'} has sent you a friend request";
      case '2':
        return "${notification.user?.username ??
            'Unknown'} has accepted your friend request";
      case '3':
        return "${notification.user?.username ??
            'Unknown'} has posted a new post";
      case '4':
        return "${notification.user?.username ?? 'Unknown'} has edit a post";
      case '5':
        return "${notification.user?.username ?? 'Unknown'} has felt your post";
      case '6':
        return "${notification.user?.username ??
            'Unknown'} has commented your post";
      case '7':
        return "${notification.user?.username ??
            'Unknown'} has replied to your comment";
      case '8':
        return "${notification.user?.username ??
            'Unknown'} has posted a new video";
      case '9':
        return "${notification.user?.username ??
            'Unknown'} has commented your post";
      default:
        return 'Unknown notification';
    }
  }
}
