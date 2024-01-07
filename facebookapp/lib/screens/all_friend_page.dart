import 'package:fb_app/services/api/friend.dart';
import 'package:flutter/material.dart';
import 'package:fb_app/models/friend_model.dart';
import 'package:fb_app/screens/profile_screen.dart';
import 'package:logger/logger.dart';

import '../core/pallete.dart';

class AllFriendPage extends StatefulWidget {
  final List<Friend> userFriendList;
  final Function()? reloadFriendsList;
  const AllFriendPage({Key? key, required this.userFriendList, required this.reloadFriendsList})
      : super(key: key);

  @override
  State<AllFriendPage> createState() => _AllFriendPageState();
}

class _AllFriendPageState extends State<AllFriendPage> {

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

  void unfriend(userId) async {
    try {
      String? resp = await FriendAPI().unfriend(
          userId
      );
      if (resp != null) {
        Logger().d('Unfriend');
        widget.reloadFriendsList!();
        showTimedAlertDialog('Success', 'Unfriended successfully.', Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Unfriend: $error');
      showTimedAlertDialog('Error', 'Failed to unfriend.', Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Friend> userFriendList = widget.userFriendList;

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách bạn bè')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userFriendList.length,
              itemBuilder: (BuildContext context, int index) {
                Friend item = userFriendList[index];

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the profile screen when tapped
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(id: item.id!, type:'2')));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(56),
                                    child: Image.network(
                                      item.avatar != null
                                          ? item.avatar!
                                          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 0, 0, 0),
                                    child: Text(
                                      item.username!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 0, 0, 0),
                                    child: Text(
                                      '${item.sameFriends!} bạn chung',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Spacer(),
                                      FilledButton(
                                        onPressed: () {
                                          unfriend(item.id);
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
                                            Icon(Icons.check),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text("Unfriend"),
                                          ],
                                        ),
                                      )
                                  //   ],
                                  // )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
