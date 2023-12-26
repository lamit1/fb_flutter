import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

import '../models/post_model.dart';
import '../models/post_response.dart';
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
  late UserInfo user =  UserInfo();
  late List<Post> posts = [];
  int index = 0;
  int count = 2;
  String lastId = "0";
  bool isLoadingPost = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoadingPost) {
        setState(() {
          isLoadingPost = true;
        });
        loadMorePosts();
      }
    });
    loadPosts();
  }

  void loadPosts() async {
    try {
      PostResponse? postResponse = await PostAPI().getListVideos(
          '1',
          '1',
          '1.0',
          '1.0',
          lastId,
          index.toString(),
          count.toString()
      );
      if (postResponse != null) {
        setState(() {
          posts = postResponse.posts;
          lastId = postResponse.lastId;
          isLoadingPost = false;
          index += count;
        });
      }
    } catch (error) {
      Logger().d('Error loading posts: $error');
    }
  }

  void loadMorePosts() async {
    try {
      PostResponse? postResponse = await PostAPI().getListVideos(
          '1', '1', '1.0', '1.0', lastId.toString(), index.toString(), count.toString()
      );
      if (postResponse != null && postResponse.posts.isNotEmpty) {
        setState(() {
          posts.addAll(postResponse.posts);
          lastId = postResponse.lastId;
          index += count;
          isLoadingPost = false;
        });
      } else {
        print(posts.length);
        setState(() {
          isLoadingPost = false;
        });
      }
    } catch (error) {
      Logger().d('Error loading more posts: $error');
      setState(() {
        isLoadingPost = false;
      });
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
            childCount: index,
          ),
        ),
        SliverToBoxAdapter(
          child: isLoadingPost ? const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 8.0),
            child: Center(child: CircularProgressIndicator()),
          ) : Container(),
        ),
      ],
    );
  }
}
