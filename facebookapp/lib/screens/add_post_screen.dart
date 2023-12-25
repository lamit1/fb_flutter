import 'dart:io';
import 'dart:typed_data';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/services/api/post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends StatefulWidget {
  UserInfo user;
  AddPostScreen({super.key, required this.user});
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<Uint8List> _images = [];
  final TextEditingController captionController = TextEditingController();
  File? video;
  VideoPlayerController? videocontroller;
  UserInfo user = UserInfo();

  _selectVideo() async {
    final videopicked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videopicked != null) {
      video = File(videopicked.path);
      videocontroller = VideoPlayerController.file(video!)
        ..initialize().then((_) {
          setState(() {});
          videocontroller!.play();
          videocontroller!.setLooping(true);
        });
    }
  }



  _selectImages(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      List<Uint8List> files = await Future.wait(
        images.map((XFile image) async {
          return await image.readAsBytes();
        }),
      );

      setState(() {
        _images.addAll(files);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Create Post'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {

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
                  backgroundImage: NetworkImage(widget.user.avatar ?? "default_image_url"),
                ),
                title: Text("${widget.user.username}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
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
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: TextFormField(
                  style: const TextStyle(fontSize: 18),
                  minLines: 4,
                  maxLines: 20,
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
                height: 400, // Set a specific height based on your design
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 1.0,
                  ),
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.memory(
                          _images[index],
                          height: screenHeight / 4,
                          width: _images.length == 1
                              ? screenWidth // Set width to screen width if there's only one image
                              : screenWidth / 2, // Otherwise, use half screen width
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
              ) : const SizedBox.shrink(),
              video == null
                  ? const SizedBox.shrink()
                  : ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400, maxWidth: 300),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                        videocontroller!.value.isPlaying
                            ? videocontroller!.pause()
                            : videocontroller!.play();
                      },
                      child: AspectRatio(
                        aspectRatio: videocontroller!.value.aspectRatio,
                        child: VideoPlayer(videocontroller!),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              videocontroller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 50,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                videocontroller!.value.isPlaying
                                    ? videocontroller!.pause()
                                    : videocontroller!.play();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            // Add logic to delete the video
                            videocontroller!.pause();
                            videocontroller!.dispose();
                            videocontroller = null;
                            video = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
