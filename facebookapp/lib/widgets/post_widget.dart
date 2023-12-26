
import 'dart:ffi';

import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/kudos_dissapointed_model.dart';
import 'package:fb_app/models/post_detail_model.dart';
import 'package:fb_app/services/api/comment.dart';
import 'package:fb_app/services/api/post.dart';
import 'package:fb_app/utils/converter.dart';
import 'package:fb_app/widgets/comment_box.dart';
import 'package:fb_app/widgets/report_post_widget.dart';
import 'package:fb_app/widgets/video_post.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import '../models/post_model.dart';
import '../services/api/block.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final String uid;
  final VoidCallback loadPosts;
  final Function(String, String) addMark;

  PostWidget({required this.post, required this.uid, required this.loadPosts, required this.addMark});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late PostDetail postDetail = PostDetail();

  Future<void> getPost() async {
    try {
      PostDetail? posts = await PostAPI().getPost(widget.post.id!);
      if (posts != null) {
        setState(() {
          postDetail = posts;
        });
      }
    } catch (e) {
      print("Error fetching post: $e");
    }
  }

  void updateMark() {
    setState(() {
      postDetail.isMarked = "1";
      widget.addMark(postDetail.id!,(int.parse(widget.post.commentMark!)+1).toString());
    });
  }


  @override
  void initState() {
    super.initState();
    getPost();
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
                      backgroundImage: NetworkImage(widget.post.user?.avatar ?? "assets/avatar.png"),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.user?.name ?? "Username",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          convertTimestamp(widget.post.created!),
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
                    postDetail.canEdit == "1" ?
                    _showUserPostOption(postContext) : _showNonUserPostOption(context);
                  },
                  splashRadius: 20,
                ),
              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.post.described!),
          ),
          if (true)
            _buildImageSection(widget.post.image!.map((i) => i.url!).toList(), postContext),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0,15.0,20.0,10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){},
                  child: Row(
                    children: [
                      (int.parse(postDetail.disappointed ?? "0") + int.parse(postDetail.kudos ?? "0")) == 0 ?
                          const Icon(Icons.sentiment_neutral_sharp,
                            size: 30,
                            color: Palette.facebookBlue,) : Container(),
                      (int.parse(postDetail.kudos ?? "0") > 0) ? const Icon(
                        Icons.sentiment_very_satisfied,
                        size: 30,
                        color: Palette.facebookBlue,
                        fill: 1,
                      ) : Container(),
                      (int.parse(postDetail.disappointed ?? "0") > 0) ? const Icon(
                        Icons.sentiment_dissatisfied_rounded,
                        size: 30,
                        color: Palette.facebookBlue,
                      ) : Container(),
                      const SizedBox(width: 8,),
                      Text(
                        (int.parse(postDetail.disappointed ?? "0") + int.parse(postDetail.kudos ?? "0")).toString(),
                        style: const TextStyle(fontSize: 20, color: Colors.grey),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Row(
                    children: [
                      const SizedBox(width: 15,),
                      Text(
                        "${widget.post.commentMark!} comments",
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 10.0, thickness: 1.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.grey)),
                      onPressed: () async {
                        Like like;
                        if(postDetail.isFelt == "1") {
                          like =  await CommentAPI().deleteFeel(widget.post.id!);
                          if (like != null) {
                            setState(() {
                              postDetail.disappointed = like.disappointed;
                              postDetail.kudos = like.kudos;
                              postDetail.isFelt = "-1";
                            });
                          }
                        } else {
                          like = await CommentAPI().feel(widget.post.id!, "1");
                          if (like != null) {
                            setState(() {
                              postDetail.disappointed = like.disappointed;
                              postDetail.kudos = like.kudos;
                              postDetail.isFelt = "1";
                            });
                          }
                        }
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Icon(
                            Icons.sentiment_very_satisfied_sharp,
                            color: postDetail.isFelt == "1" ?
                            Colors.orange : null,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(postDetail.kudos ?? "loading"),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 0.1,
                    thickness: 1,
                  ),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.grey)),
                      onPressed: () async {
                        Like like;
                        if(postDetail.isFelt == "0") {
                          like =  await CommentAPI().deleteFeel(widget.post.id!);
                          if (like != null) {
                            setState(() {
                              postDetail.disappointed = like.disappointed;
                              postDetail.kudos = like.kudos;
                              postDetail.isFelt = "-1";
                            });
                          }
                        } else {
                          like = await CommentAPI().feel(widget.post.id!, "0");
                          if (like != null) {
                            setState(() {
                              postDetail.disappointed = like.disappointed;
                              postDetail.kudos = like.kudos;
                              postDetail.isFelt = "0";
                            });
                          }
                        }
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied_rounded,
                            color: postDetail.isFelt == "0" ?
                            Colors.deepPurpleAccent : null,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(postDetail.disappointed ?? "loading"),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 0.1,
                    thickness: 1,
                  ),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.grey)),
                      onPressed: () {
                        _showCommentDialog(postContext);
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment, color: postDetail.isMarked == "1" ? Colors.green : Colors.grey ,),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(widget.post.commentMark!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(List<String> imageUrls, BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width;

    // Check if there is a video
    if (widget.post.video != null && widget.post.video!.url != null) {
      // If there is a video, display it
      return VideoPlayerWidget(videoUrl: widget.post.video!.url!);
    } else if (imageUrls.isNotEmpty) {
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

  Future _showCommentDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          initialChildSize: 0.9,
          builder: (context, scrollController) =>
              CommentBottomSheet(scrollController: scrollController, id: widget.post.id, uid : widget.uid, updateMark : updateMark),
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
                    onPressed: () {  },
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
                    style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {
                      showReportModal(context, widget.post.id!);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.report_problem_rounded, size: 35,),
                        SizedBox(width: 25,),
                        Text("Report post", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                  const Divider(height: 1.5, color: Colors.black54,),
                  TextButton(
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder:
                              (BuildContext
                          context) {
                            return  AlertDialog(
                              title: Text(
                                "Block \"${postDetail.user!.name!}\"",
                              ),
                              content: Text(
                                  "Are you sure to block \"${postDetail.user!.name!}\""),
                              actions: [
                                TextButton(
                                    onPressed:
                                        () async {
                                          await BlockAPI().setBlock(postDetail.user!.id!);
                                          widget.loadPosts();
                                          Navigator.of(context).pop();
                                          Navigator.of(postContext).pop();
                                    },
                                    child: const Text("Block")
                                ),
                                TextButton(
                                    onPressed:
                                        () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                        "Cancel")),
                              ],
                            );
                          });
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.block_sharp, size: 35,),
                        const SizedBox(width: 25,),
                        Text("Block \"${postDetail.user!.name}\"", style: const TextStyle(fontSize: 15),)
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


