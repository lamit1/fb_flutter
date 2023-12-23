import 'package:fb_app/services/api/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../models/post_model.dart';
import '../models/user_info_model.dart';
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
  void loadVideos() async {
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
      Logger().d('Error loading posts: $error');
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
  void initState() {
    loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    print(123);
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
                loadPosts: loadVideos,
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
