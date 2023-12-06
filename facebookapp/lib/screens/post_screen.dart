import 'package:flutter/widgets.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../widgets/create_post_container.dart';
import '../widgets/post_widget.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key}) : super(key: key);
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);



  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: CreatePostContainer(currentUser: User()),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              // return PostWidget(post: Post(id: '1', name: '2', created: '3', described: '4', feel: '5', commentMark: '6', isFelt: '1',));
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}
