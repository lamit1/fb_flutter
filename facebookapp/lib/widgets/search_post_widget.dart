import 'package:fb_app/models/post_detail_model.dart';
import 'package:fb_app/widgets/video_post.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_layout/image_model.dart';
import 'package:multi_image_layout/multi_image_viewer.dart';

import '../models/search_model.dart';
import '../services/api/post.dart'; // Import your SearchPost model
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

  Widget _buildImageSection(List<String>? imageUrls, BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width;

    // Check if there is a video
    if (searchPostDetail.video != null && searchPostDetail.video!.url != null) {
      // If there is a video, display it
      return VideoPlayerWidget(videoUrl: searchPostDetail.video!.url!);
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
          // ... Rest of the widget code
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(searchPostDetail.described ?? "Loading ..."),
          ),
          // Assuming the _buildImageSection method is adapted for SearchPost
          if (searchPostDetail.image != null && searchPostDetail.image!.isNotEmpty)
            _buildImageSection(searchPostDetail.image!.map((i) => i.url!).toList(), postContext),
          // ... Rest of the widget code
        ],
      ),
    );
  }
}