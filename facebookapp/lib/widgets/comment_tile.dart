// import 'package:flutter/material.dart';
//
// class CommentTile extends StatelessWidget {
//   final Comment comment;
//
//   CommentTile({required this.comment});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero, // Remove default ListTile padding
//       leading: GestureDetector(
//         onTap: () {
//           // Display the image in large form.
//           print("Comment Clicked");
//         },
//         child: Container(
//           height: 50.0,
//           width: 50.0,
//           decoration: const BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.all(Radius.circular(50)),
//           ),
//           child: CircleAvatar(
//             radius: 50,
//             // Use your image loading logic here
//             // CommentBox.commentImageParser(imageURLorPath: comment.pic),
//           ),
//         ),
//       ),
//       title: Text(
//         comment.name,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(comment.message),
//           Text(comment.date, style: const TextStyle(fontSize: 10)),
//         ],
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextButton(onPressed: () {}, child: Text("Like")),
//           TextButton(onPressed: () {}, child: Text("Reply")),
//           TextButton(onPressed: () {}, child: Text("Report")),
//         ],
//       ),
//     );
//   }
// }
