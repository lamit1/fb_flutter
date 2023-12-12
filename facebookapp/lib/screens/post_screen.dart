import 'package:fb_app/models/post_detail_model.dart';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/services/api/post.dart';
import 'package:fb_app/services/api/profile.dart';
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
  late UserInfo user;
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    loadPosts();
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
      List<Post>? fetchedPosts = await PostAPI().getListPosts(
        widget.uid!,
        '1',
        '1',
        "1.0",
        "1.0",
        '0',
        "0",
        "10"
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
              return PostWidget(post: posts[index]);
            },
            childCount: 5,
          ),
        ),
      ],
    );
  }
}
