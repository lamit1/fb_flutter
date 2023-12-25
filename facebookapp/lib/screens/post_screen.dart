
import 'package:fb_app/models/post_response.dart';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/services/api/post.dart';
import 'package:fb_app/services/api/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import '../models/post_model.dart';
import '../widgets/create_post_container.dart';
import '../widgets/post_widget.dart';

class PostScreen extends StatefulWidget {
  final String? uid;
  PostScreen({Key? key, required this.uid}) : super(key: key);
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  late UserInfo user = const UserInfo();
  late List<Post> posts = [];
  bool isLoadingPost = true;
  int index = 0;
  int count = 5;
  String lastId = "0";

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
    loadUserInfo();
    loadPosts();
  }

  void loadMorePosts() async {
    try {
      PostResponse? postResponse = await PostAPI().getListPosts(
          '1', '1', '1.0', '1.0', lastId.toString(), index.toString(), count.toString()
      );
      if (postResponse != null && postResponse.posts.isNotEmpty) {
        Logger().d("POST LAST ID: ${postResponse.lastId}");
        setState(() {
          posts.addAll(postResponse.posts);
          lastId = postResponse.lastId;
          isLoadingPost = false;
          index += count;
        });
      } else {
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  // Function to load user information
  void loadUserInfo() async {
    try {
      UserInfo userInfo = await ProfileAPI().getUserInfo(widget.uid!);
      setState(() {
        user = userInfo;
      });
    } catch (error) {
      Logger().d('Error loading user info: $error');
    }
  }

  void loadPosts() async {
    try {
      PostResponse? postResponse = await PostAPI().getListPosts(
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
        SliverToBoxAdapter(
          child: CreatePostContainer(currentUser: user),
        ),
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
