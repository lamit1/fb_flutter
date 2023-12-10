
import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/post_detail_model.dart';
import 'package:fb_app/widgets/comment_box.dart';
import 'package:fb_app/widgets/video_post.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import '../models/post_model.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({required this.post});


  @override
  Widget build(BuildContext postContext) {
    print(post.image);
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
                      backgroundImage: NetworkImage(post.user?.avatar ?? "/assets/avatar.png"),
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.user?.name ?? "Username",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(DateTime.parse(post.created ?? "01/01/1970")),
                          style: TextStyle(
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
            padding: EdgeInsets.all(8.0),
            child: Text(post.described!),
          ),
          if (true)
            _buildImageSection(post.image!.map((i) => i.url!).toList(), postContext),
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
                          Icon(Icons.thumb_up, color: true ? null : Palette.facebookBlue,),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(post.feel.toString()),
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
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(post.commentMark!),
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TODO: Intergrate the true
                          Icon(Icons.share, color: true ? null : Palette.facebookBlue,),
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
    if (post.video != null && post.video!.url != null) {
      // If there is a video, display it
      return VideoPlayerWidget(videoUrl: post.video!.url!);
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


