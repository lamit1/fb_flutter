import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/services/api/block.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BlockCard extends StatelessWidget {
  final User user;
  final Function()? reloadBlockList;
  final BuildContext context;

  const BlockCard({super.key, required this.user, required this.context, this.reloadBlockList});

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

  void unblock(userId) async {
    try {
      String? resp = await BlockAPI().unBlock(
        userId,
      );
      if (resp != null) {
        Logger().d('UnBlock Friend');
        reloadBlockList!();
        showTimedAlertDialog('Success', 'UnBlock successfully.', Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Accept: $error');
      showTimedAlertDialog('Error', 'Failed to unblock request.', Duration(seconds: 2));
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
              backgroundImage: NetworkImage(user.avatar!),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      FilledButton(
                        onPressed: () {
                          unblock(user.id);
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
                            Text("UnBlock"),
                          ],
                        ),
                      )
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
