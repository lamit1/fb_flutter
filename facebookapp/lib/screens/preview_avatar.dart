import 'dart:io';

import 'package:fb_app/services/api/profile.dart';
import 'package:flutter/material.dart';

import '../models/user_info_model.dart';

class PreviewAvatar extends StatefulWidget {
  final String imagePath;
  final UserInfo userInfor;

  const PreviewAvatar(
      {Key? key, required this.imagePath, required this.userInfor})
      : super(key: key);

  @override
  State<PreviewAvatar> createState() => _PreviewAvatarState();
}

class _PreviewAvatarState extends State<PreviewAvatar> {
  void popBackScreen() {
    Navigator.pop(context);
  }

  void saveImage() async {
    File imageFile = File(widget.imagePath);

    await ProfileAPI().setUserInfo(
        widget.userInfor.username!,
        widget.userInfor.description!,
        imageFile,
        widget.userInfor.address!,
        widget.userInfor.city!,
        widget.userInfor.country!,
        null,
        widget.userInfor.link!);

    popBackScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Xem trước ảnh'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save image',
              onPressed: () {
                saveImage();
              },
            ),
          ],
        ),
        body: CircleAvatar(
          radius: 200,
          backgroundImage: FileImage(File(widget.imagePath)),
        ));
  }
}
