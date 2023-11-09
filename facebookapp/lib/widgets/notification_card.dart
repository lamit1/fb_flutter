import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Colors.grey,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Stack(
                    children: [
                      // Avatar Image
                      CircleAvatar(
                        backgroundImage: NetworkImage(onlineUsers[0].imageUrl!),
                        radius: 30.0,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
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
                        "${onlineUsers[0].name} has liked your post",
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      const Text(
                        "5 mins ago",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      IconButton(
                          onPressed: () {},
                          splashRadius: 20.0,
                          icon: const Icon(
                            Icons.more_vert,
                            color: Palette.facebookBlue,
                          )),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
