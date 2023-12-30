import 'dart:collection';
import 'dart:io';
import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/services/api/post.dart';
import 'package:fb_app/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Make sure this package is included in your pubspec.yaml
import 'package:video_player/video_player.dart';
import 'package:fb_app/models/post_detail_model.dart';

import '../models/video_model.dart'; // Import your PostDetail model


class EditPostScreen extends StatefulWidget {
  final PostDetail postDetail;
  Function() reloadPost;
  EditPostScreen({super.key, required this.postDetail, required  this.reloadPost});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController _describeController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<Image> images = [];
  List<File> _selectedImages = [];
  File? _selectedVideo;
  VideoPlayerController? videoController;
  IconData iconStatus = Icons.play_arrow;
  List<int> deletedImages = [];
  List<int> imageOrder = [];
  HashMap<Image, bool> deletedNetworkImageMap = HashMap();
  int networkImageLength = 0;
  bool isDeletedImage = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _describeController.text = widget.postDetail.described!;
    _statusController.text = widget.postDetail.state!;
    if (widget.postDetail.image != null) {
      images = widget.postDetail.image!
          .map((imageModel) => Image.network(imageModel.url!))
          .toList();
      setState(() {
        images.asMap().forEach((index,image) {
          deletedNetworkImageMap[image] = false;
        });
        networkImageLength = images.length;
        imageOrder = List.generate(images.length, (index) => index+1);
      });
    }
    print(imageOrder);
    // Initialize video
    if (widget.postDetail.video != null) {
      videoController =
          VideoPlayerController.network(widget.postDetail.video!.url!)
            ..initialize().then((_) {
              setState(() {});
              iconStatus = Icons.play_arrow;
            });
    }
  }
  @override
  void dispose() {
    _describeController.dispose();
    videoController?.dispose();
    _statusController.dispose();
    super.dispose();
  }
  void moveImage(int oldIndex, int newIndex) {
    setState(() {
      final Image tempImage = images[oldIndex];
      final int tempId = imageOrder[oldIndex];

      images[oldIndex] = images[newIndex];
      images[newIndex] = tempImage;

      imageOrder[oldIndex] = imageOrder[newIndex];
      imageOrder[newIndex] = tempId;
    });
  }
  Widget _buildImagePreview() {
    return Wrap(
      spacing: 8.0,
      children: images.asMap().entries.map((entry) {
        int index = entry.key;
        Image image = entry.value;
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      // red for the network image was deleted
                      // green for normal
                      // blue for image was added
                      color: deletedNetworkImageMap[image] != null ?
                      deletedNetworkImageMap[image] == true ?
                      Colors.red : Colors.green
                      : Palette.facebookBlue,
                      width: 4
                    )
                  ),
                  width: 200,
                  height: 200,
                  child: image,
                ),
                const SizedBox(height: 10,)
              ],
            ),
            Positioned(
              top: 10, // Adjust this value as needed
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    icon: isDeletedImage ? Container() : const Icon(Icons.arrow_upward, color: Colors.green),
                    onPressed: index == 0 ? null : () =>
                    {
                      moveImage(index, index - 1),
                      print(imageOrder)
                    },
                  ),
                  IconButton(
                    icon: isDeletedImage ? Container() : const Icon(Icons.arrow_downward, color: Colors.blue),
                    onPressed: index == images.length - 1 ? null : () =>
                    {
                      moveImage(index, index + 1),
                      print(imageOrder)
                    },
                  ),
                  IconButton(
                    icon: deletedNetworkImageMap[image] == true ? const Icon(Icons.redo, color: Colors.yellow) :  const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        if(deletedNetworkImageMap[image] != null ){
                          if(deletedNetworkImageMap[image] == true) {
                            deletedNetworkImageMap[image] = false;
                            deletedImages.remove(index);
                          } else {
                            deletedNetworkImageMap[image] = true;
                            deletedImages.add(index);
                          }
                        } else {
                            images.removeAt(index);
                            imageOrder.removeAt(index);
                        }
                        print(deletedImages);
                        print(isDeletedImage);
                      });
                      checkDeletedNetwork();
                    },
                  ),
                ],
              ),
            )
          ],
        );
      }).toList() ?? [],
    );
  }
  Widget _buildVideoWidget() {
    return videoController != null &&
            videoController?.value.isInitialized == true
        ? Center(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 200,
                      child: AspectRatio(
                        aspectRatio: videoController!.value.aspectRatio,
                        child: VideoPlayer(videoController!),
                      ),
                    ),
                    Positioned(
                      child: IconButton(
                        icon: Icon(iconStatus, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            if (videoController!.value.isPlaying) {
                              videoController!.pause();
                              iconStatus = Icons.play_arrow;
                            } else {
                              if (videoController!.value.position.inSeconds >=
                                  videoController!.value.duration.inSeconds -
                                      1) {
                                videoController!.seekTo(Duration.zero);
                              }
                              videoController!.play();
                              iconStatus = Icons.pause;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
  Future<void> _pickMedia(bool isImage) async {
    if (isDeletedImage) return;
    //TODO: Implement show the error box cannot add image if delete file
    if (isImage) {
      final pickedFiles = await _picker.pickMultiImage();
      int startingIndex = images.length;  // Starting index based on the length of images
      List<int> indexList = List.generate(
          pickedFiles.length,
              (index) => startingIndex + index +1
      );
      setState(() {
        if(images.length == 4) return;
        images.addAll(pickedFiles.map((xFile) => Image.file(File(xFile.path))).toList());
        _selectedImages = pickedFiles.map((xFile) => File(xFile.path)).toList();
        imageOrder.addAll(indexList);
        videoController?.dispose();
        videoController = null; // Reset the video controller if images are picked
      });
    } else {
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          // Dispose the previous video controller if it exists
          videoController?.dispose();
          _selectedVideo = File(pickedFile.path);
          videoController = VideoPlayerController.file(File(pickedFile.path))
            ..initialize().then((_) {
              setState(() {});
              iconStatus = Icons.play_arrow;
            });
          images.removeWhere((image) => deletedNetworkImageMap[image] == null);
          images.asMap().forEach((key, value) {
            if(deletedNetworkImageMap[value] != null) {
              deletedNetworkImageMap[value] = true;
            }
          });
        });
      }
    }
    print(imageOrder);
  }
  void checkDeletedNetwork() {
    bool foundDeleted = false;
    for (var image in images) {
      if (deletedNetworkImageMap[image] == true) {
        foundDeleted = true;
        break; // Exit the loop as a deleted image is found
      }
    }
    setState(() {
      isDeletedImage = foundDeleted;
    });
    if (isDeletedImage) {
      setState(() {
        images.removeWhere((image) => deletedNetworkImageMap[image] == null);
      });
    }
  }
  void showSuccessModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Post Uploaded'),
          content: const Text('Your post has been successfully updated.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                await widget.reloadPost();
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
          title: const Text('Update Failed'),
          content: const Text(
              'There was an issue updating your post. Please try again later.'),
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        appBar: AppBar(
          title: const Text("Edit Post"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String imageDel = deletedImages.join(",");
                String imageSort = imageOrder.join(",");
                String described = _describeController.text;
                String status = _statusController.text;
                String autoAccept = "1";
                String id =  widget.postDetail.id!;
                setState(() {
                  loading =true;
                });
                String? responseCode = await PostAPI().editPost(
                    _selectedImages,
                    _selectedVideo,
                    described,
                    status,
                    autoAccept,
                    id,
                    imageDel,
                    imageSort);

                if (responseCode != null) {
                  // Handle the response
                  setState(() {
                    loading = false;
                  });
                  print("Response Code: $responseCode");
                  showSuccessModal();
                } else {
                  showFailedModal();
                  // Handle the error
                  print("Failed to edit post");
                }
              },
              child: const Icon(Icons.save_alt),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15,),
                TextFormField(
                  controller: _statusController,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _describeController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickMedia(true), // For selecting images
                      child: const Icon(Icons.image),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickMedia(false), // For selecting video
                      child: const Icon(Icons.video_collection),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildImagePreview(),
                _buildVideoWidget(),
              ],
            ),
          ),
        ),
      ),
        loading ? const Center(child: CircularProgressIndicator()) : Container()
      ]
    );
  }


}
