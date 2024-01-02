// import 'package:fb_app/widgets/post_widget.dart';
// import 'package:flutter/material.dart';
//
// class PostDetailScreen extends StatefulWidget {
//   const PostDetailScreen({super.key});
//
//   @override
//   State<PostDetailScreen> createState() => _PostDetailScreenState();
// }
//
//
//
//
// class _PostDetailScreenState extends State<PostDetailScreen>{
//
//   void loadPosts() async {
//     try {
//       PostResponse? postResponse = await PostAPI().getListPosts(
//           '1',
//           '1',
//           '1.0',
//           '1.0',
//           lastId,
//           index.toString(),
//           count.toString()
//       );
//       if (postResponse != null) {
//         setState(() {
//           posts = postResponse.posts;
//           lastId = postResponse.lastId;
//           isLoadingPost = false;
//           index += count;
//         });
//       }
//       print('loadPosts is executed in PostScreen');
//     } catch (error) {
//       Logger().d('Error loading posts: $error');
//     }
//   }
//
//   void reloadPosts() {
//     setState(() {
//       isLoadingPost = true;  // Set loading to true to show a loading indicator
//       posts.clear();          // Optionally clear existing posts before loading new ones
//       lastId = "0";           // Reset lastId if necessary
//       index = 0;              // Reset index if you're paginating
//     });
//     loadPosts();              // Call loadPosts to fetch and display new posts
//   }
//
//   void addMark(String postId, String commentMark) {
//     setState(() {
//       posts = posts.map((post) {
//         if (post.id == postId) {
//           // Update the commentMark for the matching post
//           post.commentMark = commentMark;
//         }
//         return post;
//       }).toList();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title:  Text("Post Detail"),),
//         body: PostWidget(
//             post: post,
//             uid: uid,
//             loadPosts: loadPosts,
//             addMark: addMark)
//     );
//   }
// }
