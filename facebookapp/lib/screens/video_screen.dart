import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/post_model.dart';
import '../models/user_info_model.dart';
import '../services/api/post.dart';
import '../services/api/profile.dart';
import '../widgets/post_widget.dart';



class VideoScreen extends StatefulWidget {
  final String? uid;
  VideoScreen({Key? key, required this.uid}) : super(key: key);
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  late UserInfo user = const UserInfo();
  late List<Post> posts = [];
  int index = 0;
  int count = 10;
  int lastId = 0;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  void loadPosts() async {
    try {
      List<Post>? fetchedPosts = await PostAPI().getListVideos(
          '1',
          '1',
          '1.0',
          '1.0',
          lastId.toString(),
          index.toString(),
          count.toString()
      );
      if (fetchedPosts != null) {
        setState(() {
          posts = fetchedPosts;
        });
      }
    } catch (error) {
      print('Error loading posts: $error');
    }
  }

  void addMark(String postId, String commentMark) {
    setState(() {
      posts = posts.map((post) {
        if (post.id == postId) {
          // Update the commentMark for the matching post
          post.commentMark = commentMark;
        }
        return post;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return posts.isNotEmpty ?
              PostWidget(
                post: posts[index],
                uid: widget.uid!,
                loadPosts: loadPosts,
                addMark: addMark,
              ) : Container();
            },
            childCount: count,
          ),
        ),
      ],
    );
  }
}
