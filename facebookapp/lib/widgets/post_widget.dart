
import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/widgets/comment_box.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import '../models/post_model.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({required this.post});


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
                      backgroundImage: NetworkImage("url"),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "username",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "post.timeAgo",
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
                    _showNonUserPostOption(postContext);
                  },
                  splashRadius: 20,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("post.caption"),
          ),
          if (true)
            _buildImageSection(["123","123"], postContext),
          const Divider(height: 10.0, thickness: 1.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        print("Press Like");
                      },
                      style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TODO: Intergrate the true
                          const Icon(Icons.thumb_up, color: true ? null : Palette.facebookBlue,),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text("post.likes.toString()"),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.grey)),
                      onPressed: () {
                        print("Press Comment!");
                        _showCommentDialog(postContext);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.comment),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text("comment"),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 20,
                    thickness: 1,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        print("Press Like");
                      },
                      style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TODO: Intergrate the true
                          const Icon(Icons.share, color: true ? null : Palette.facebookBlue,),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text("123"),
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
    return MultiImageViewer(
      images: imageUrls.map((url) => ImageModel(imageUrl: url)).toList(),
      width: imageWidth,
    );
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
              CommentBottomSheet(scrollController: scrollController,),
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
          minChildSize: 0.5,
          maxChildSize: 0.75,
          initialChildSize: 0.6,
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
                        Icon(Icons.circle_notifications_rounded, size: 35,),
                        SizedBox(width: 25,),
                        Text("Turn off notification", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                  const Divider(height: 1.5, color: Colors.black54,),
                  TextButton(
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {  },
                    child: const Row(
                      children: [
                        Icon(Icons.save_alt, size: 35,),
                        SizedBox(width: 25,),
                        Text("Save post", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                  const Divider(height: 1.5, color: Colors.black54,),
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
                  const Divider(height: 1.5, color: Colors.black54,),
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
                  const Divider(height: 1.5, color: Colors.black54,),
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
  void _showNonUserPostOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          initialChildSize: 0.6,
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
                        Icon(Icons.circle_notifications_rounded, size: 35,),
                        SizedBox(width: 25,),
                        Text("Turn on notification", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                  const Divider(height: 1.5, color: Colors.black54,),
                  TextButton(
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {  },
                    child: const Row(
                      children: [
                        Icon(Icons.report_problem, size: 35,),
                        SizedBox(width: 25,),
                        Text("Report post", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                  const Divider(height: 1.5, color: Colors.black54,),
                  TextButton(
                    style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black54)),
                    onPressed: () {  },
                    child: const Row(
                      children: [
                        Icon(Icons.save_alt, size: 35,),
                        SizedBox(width: 25,),
                        Text("Save post", style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  ),
                  const Divider(height: 1.5, color: Colors.black54,),
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

}


