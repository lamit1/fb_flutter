import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/friend_model.dart';
import 'package:fb_app/services/api/friend.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FriendCard extends StatelessWidget {
  final Friend friend;
  final String tag;
  final Function()? reloadFriendList;
  final BuildContext context;

  FriendCard({required this.friend, required this.tag, required this.context, this.reloadFriendList});

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
        reloadFriendList!();
        showTimedAlertDialog('Success', 'Friend request accepted successfully.', Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Accept: $error');
      showTimedAlertDialog('Error', 'Failed to accept friend request.', Duration(seconds: 2));
    }
  }

  void unfriend(userId) async {
    try {
      String? resp = await FriendAPI().unfriend(
        userId
      );
      if (resp != null) {
        Logger().d('Unfriend');
        reloadFriendList!();
        showTimedAlertDialog('Success', 'Unfriended successfully.', Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Unfriend: $error');
      showTimedAlertDialog('Error', 'Failed to unfriend.', Duration(seconds: 2));
    }
  }

  void addFriend(userId) async {
    try {
      String? resp = await FriendAPI().setRequestFriend(
          userId
      );
      if (resp != null) {
        Logger().d('add Friend');
        reloadFriendList!();
        showTimedAlertDialog('Success', 'Friend request sent successfully.', Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Add: $error');
      showTimedAlertDialog('Error', 'Failed to send friend request.', Duration(seconds: 2));
    }
  }

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
                          onPressed: () {
                            accept(friend.id,'1');
                          },
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
                          onPressed: () {
                            addFriend(friend.id);
                          },
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
                      if (tag == 'request')
                        FilledButton(
                            onPressed: () {
                              if(tag == 'request'){
                                accept(friend.id,'0');
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
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
                      else if (tag == 'friend')
                        FilledButton(
                            onPressed: () {
                              unfriend(friend.id);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
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
                            ))
                      else
                        Container(),
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
