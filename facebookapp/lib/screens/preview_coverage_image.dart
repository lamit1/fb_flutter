import 'dart:io';

import 'package:fb_app/services/api/profile.dart';
import 'package:flutter/material.dart';

import '../models/user_info_model.dart';


class PreviewCoverageImage extends StatefulWidget {
  final String imagePath;
  final UserInfo userInfo;

  const PreviewCoverageImage(
      {Key? key, required this.imagePath, required this.userInfo})
      : super(key: key);

  @override
  State<PreviewCoverageImage> createState() => _PreviewCoverageImageState();
}

class _PreviewCoverageImageState extends State<PreviewCoverageImage> {
  void popBackScreen() {
    Navigator.pop(context);
  }

  void saveImage() async {
    File imageFile = File(widget.imagePath);
    await ProfileAPI().setUserInfo(
        widget.userInfo.username!,
        widget.userInfo.description!,
        null ,
        widget.userInfo.address!,
        widget.userInfo.city!,
        widget.userInfo.country!,
        imageFile,
        widget.userInfo.link!);
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
        body: Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox(
                  width: double.infinity,
                  height: 400, // Image radius
                  child: Image(
                    image: FileImage(File(widget.imagePath)),
                    fit: BoxFit.cover,
                  ),
                ))));
  }
}
