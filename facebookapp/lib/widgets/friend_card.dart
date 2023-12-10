import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/friend_model.dart';
import 'package:flutter/material.dart';

class FriendCard extends StatelessWidget {
  final Friend friend;

  final String tag;

  FriendCard({required this.friend, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: NetworkImage(friend.avatar!),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.username!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text('${friend.sameFriends!} bạn chung'),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (tag == 'request')
                        FilledButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Palette.facebookBlue),
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
                        )
                      else if (tag == 'suggest')
                        FilledButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Palette.facebookBlue),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.add),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("Add friend"),
                            ],
                          ),
                        )
                      else
                        Container(),
                      if (tag == 'request' || tag == 'suggest')
                        FilledButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Palette.scaffold),
                              foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                              overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
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
                      else
                        FilledButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Palette.scaffold),
                              foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                              overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
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
                                Text("Unfriend"),
                              ],
                            )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
