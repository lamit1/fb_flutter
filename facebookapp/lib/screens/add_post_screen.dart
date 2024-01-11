import 'dart:io';
import 'dart:typed_data';
import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/add_post_response.dart';
import 'package:fb_app/models/post_detail_model.dart';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/services/api/post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../models/post_model.dart';

class AddPostScreen extends StatefulWidget {
  UserInfo user;
  final Function? onPostAdded;

  AddPostScreen({super.key, required this.user, required this.onPostAdded});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<File> _images = [];
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  File? video;
  VideoPlayerController? videoController;
  UserInfo user = UserInfo();
  late String coins;
  bool isLoading = false;
  Post? newPost;
  IconData iconStatus = Icons.play_arrow;

  @override
  void initState() {
    setState(() {
      coins = widget.user.coins!;
    });
  }

  _selectVideo() async {
    final videopicked =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videopicked != null) {
      video = File(videopicked.path);
      videoController?.dispose(); // Dispose the old controller if it exists
      videoController = VideoPlayerController.file(video!)
        ..initialize().then((_) {
          setState(() {
            iconStatus = Icons.play_arrow;
          });
          videoController!.addListener(() {
            final bool isEndOfVideo = videoController!.value.position ==
                videoController!.value.duration;
            if (isEndOfVideo) {
              setState(() {
                iconStatus = Icons.redo;
              });
              videoController!.seekTo(Duration.zero);
            }
          });
        });
    }
  }

  _selectImages(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      setState(() {
        _images.addAll(images.map((xfile) => File(xfile.path)).toList());
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  void dispose() {
    videoController?.dispose();
    descriptionController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Widget videoWidget = video != null &&
            videoController?.value.isInitialized == true
        ? Center(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // Black background for the video
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.black,
                    ),
                    // Video Player
                    Container(
                      width: 200,
                      child: AspectRatio(
                        aspectRatio: videoController!.value.aspectRatio,
                        child: VideoPlayer(videoController!),
                      ),
                    ),
                    // Play/Pause Button
                    Positioned(
                      child: IconButton(
                        icon: Icon(
                          iconStatus,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            // If the video is playing, pause it
                            if (videoController!.value.isPlaying) {
                              videoController!.pause();
                              setState(() {
                                iconStatus = Icons.play_arrow;
                              });
                            } else {
                              // If the video is at or near the end, reset to the beginning
                              if (videoController!.value.position.inSeconds >=
                                  videoController!.value.duration.inSeconds -
                                      1) {
                                videoController!.seekTo(Duration.zero);
                              }
                              // Play the video
                              videoController!.play();
                              setState(() {
                                iconStatus = Icons.pause;
                              });
                            }
                          });
                        },
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              videoController!.dispose();
                              videoController = null;
                              video = null;
                            });
                          },
                        ))
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Create Post'),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  String description = descriptionController.text;
                  String status = statusController.text;
                  print(video != null ? "Video null" : "Video not null");
                  AddPostResponse? response = await PostAPI()
                      .addPost(_images, video, description, status, "1");
                  if (response != null) {
                    setState(() {
                      coins = response.coins!;
                      _images = [];
                      video = null;
                    });
                    descriptionController.clear();
                    statusController.clear();
                    widget.onPostAdded!();

                    //Implement add post success modal
                    showSuccessModal();
                  } else {
                    //Implement the failed modal due to out of coins
                    showFailedModal();
                  }
                },
                child: const Text('Post'),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(widget.user.avatar ?? "default_image_url"),
                  ),
                  title: Text("${widget.user.username}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey),
                            onPressed: () {
                              _selectVideo();
                            },
                            icon: const Icon(Icons.add),
                            label: const Row(
                              children: [
                                Text('Video'),
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey),
                            onPressed: () {
                              _selectImages(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Row(
                              children: [
                                Text('Image'),
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 15.0,
                              backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7rjB8BcKmkkifnTHKogjZ3WxZItOmGgRItiyH8g9ph4xbppnClyAJg5D7WyO6Rys-OBo&usqp=CAU'
                              ),
                            ),
                            //coins
                            Text(
                              coins,
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {}, child: const Icon(Icons.add))
                          ],
                        ))
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                const Divider(height: 0.5),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 18),
                    minLines: 1,
                    maxLines: 1,
                    controller: statusController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.question_mark),
                      iconColor: Palette.facebookBlue,
                      border: InputBorder.none,
                      hintText: 'What\'s are you feeling?',
                      hintStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const Divider(
                  height: 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 18),
                    minLines: 4,
                    maxLines: 20,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'What\'s on your Mind?',
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                // Display selected images
                _images.isNotEmpty
                    ? Container(
                        height:
                            400, // Set a specific height based on your design
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 1.0,
                          ),
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Image.file(
                                  _images[index],
                                  height: screenHeight / 4,
                                  width: _images.length == 1
                                      ? screenWidth // Set width to screen width if there's only one image
                                      : screenWidth / 2,
                                  // Otherwise, use half screen width
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _removeImage(index);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                videoWidget,
              ],
            ),
          ),
        ),
      ),
      if (isLoading) // Show loading overlay when posting
        const Center(
          child: CircularProgressIndicator(),
        ),
    ]);
  }

  void showSuccessModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Post Uploaded'),
          content: const Text('Your post has been successfully uploaded.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showFailedModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Failed'),
          content: const Text(
              'There was an issue uploading your post. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
