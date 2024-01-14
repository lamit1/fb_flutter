import 'package:fb_app/models/post_detail_model.dart';
import 'package:fb_app/widgets/report_post_widget.dart';
import 'package:fb_app/widgets/video_post.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_layout/image_model.dart';
import 'package:multi_image_layout/multi_image_viewer.dart';

import '../core/pallete.dart';
import '../models/search_model.dart';
import '../screens/edit_post_screen.dart';
import '../services/api/block.dart';
import '../services/api/post.dart';
import '../utils/converter.dart'; // Import your SearchPost model
// Import other necessary packages and models

class SearchPostWidget extends StatefulWidget {
  final SearchPost searchPost;
  final String uid;
  final VoidCallback loadPosts;
  final Function(String, String) addMark;

  SearchPostWidget({
    required this.searchPost,
    required this.uid,
    required this.loadPosts,
    required this.addMark,
  });

  @override
  State<SearchPostWidget> createState() => _SearchPostWidgetState();
}

class _SearchPostWidgetState extends State<SearchPostWidget> {
  // Assuming PostDetail has similar structure to SearchPost
  PostDetail searchPostDetail = PostDetail();

  Future<void> getPost() async {
    try {
      PostDetail? post = await PostAPI().getPost(widget.searchPost.id!); // Adjust API call as per SearchPost
      if (post != null) {
        setState(() {
          searchPostDetail = post;
        });
      }
      print(post);
    } catch (e) {
      print("Error fetching post: $e");
    }
  }

  void updateMark() {
    setState(() {
      searchPostDetail.isFelt = "1";
      widget.addMark(searchPostDetail.id!, (int.parse(widget.searchPost.markComment!) + 1).toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getPost();
  }

  Widget _buildMediaSection(List<String>? imageUrls, String? videoUrl, BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width;
    print("POST: $videoUrl");
    // Check if there is a video
    if (videoUrl != null) {
      return VideoPlayerWidget(videoUrl: videoUrl);
    } else if (imageUrls!= null && imageUrls.isNotEmpty) {
      // If there are images, display them
      return MultiImageViewer(
        images: imageUrls.map((url) => ImageModel(imageUrl: url)).toList(),
        width: imageWidth,
      );
    } else {
      // If there are neither images nor videos, return an empty container
      return Container();
    }
  }


  @override
  Widget build(BuildContext postContext) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(widget.searchPost.author!.avatar ?? "assets/avatar.png"),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.searchPost.author!.name ?? "Loading Username",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "- is feeling ${searchPostDetail.state}",
                          style: const TextStyle(
                              color: Palette.facebookBlue
                          ),
                        ),
                        Text(
                          convertTimestamp(widget.searchPost.created!),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_outlined),
                  onPressed: () {
                    searchPostDetail.canEdit == "1" ?
                    _showUserPostOption(postContext) : _showNonUserPostOption(context);
                  },
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(searchPostDetail.described ?? "Loading ..."),
          ),
          _buildMediaSection(searchPostDetail.image?.map((i) => i.url!).toList(), searchPostDetail.video?.url ?? Video().url, postContext),
        ],
      ),
    );
  }

  void _showNonUserPostOption(BuildContext postContext) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.15,
          maxChildSize: 0.2,
          initialChildSize: 0.2,
          builder: (context, scrollController)
          => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextButton(
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {
                      showReportModal(context, widget.searchPost.id!);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.info, size: 35,),
                        SizedBox(width: 25,),
                        Text("Go to post detail", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showUserPostOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.2,
          maxChildSize: 0.25,
          initialChildSize: 0.25,
          builder: (context, scrollController)
          => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextButton(
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {  },
                    child: const Row(

                      children: [
                        Icon(Icons.delete,  size: 35,),
                        SizedBox(width: 25,),
                        Text("Delete post", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                  const Divider(height: 1.5, color: Colors.grey,),
                  TextButton(
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return EditPostScreen(postDetail: searchPostDetail, reloadPost: getPost);
                      }));
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.edit,  size: 35,),
                        SizedBox(width: 25,),
                        Text("Edit post", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                  const Divider(height: 3, color: Colors.grey,),
                  TextButton(
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {  },
                    child: const Row(
                      children: [
                        Icon(Icons.link,  size: 35,),
                        SizedBox(width: 25,),
                        Text("Copy link address", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void showReportModal(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return ReportModal(id: postId,);
      },
    );
  }

}