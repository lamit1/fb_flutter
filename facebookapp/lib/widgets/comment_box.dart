import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/mark_cmt_model.dart';
import 'package:fb_app/services/api/comment.dart';
import 'package:fb_app/widgets/comment_sheet.dart';
import 'package:fb_app/widgets/reply_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/cmt_model.dart';

class CommentBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final String? id; // Add id parameter

  CommentBottomSheet({Key? key, required this.scrollController, this.id}) : super(key: key);

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}


class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _key = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  late List<MarkComments>? marks;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      List<MarkComments>? marksData = await CommentAPI().getMarkComment("1", "0", "10");
      if (marksData != null) {
        setState(() {
          marks=marksData;
        });
      }
    } catch (error) {
      // Handle error if necessary
      print("Error loading comments: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(marks![0]);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scaffold(
        body: CommentBox(
          userImage: CommentBox.commentImageParser(imageURLorPath: "assets/avatar.png"),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          withBorder: false,
          sendButtonMethod: () {
            if (_key.currentState!.validate()) {
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: _key,
          commentController: commentController,
          // backgroundColor: Palette.facebookBlue,
          textColor: Colors.grey,
          sendWidget: const Icon(Icons.send_sharp, size: 30, color: Palette.facebookBlue),
          child: commentChild(marks),
        ),
      ),
    );
  }

  Widget commentChild(List<MarkComments>? marks) {
    return SingleChildScrollView(
        controller: widget.scrollController,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var i = 0; i < marks!.length; i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 15.0, 2.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              CircleAvatar(
                              radius: 32,
                              backgroundImage: marks[i].poster!.avatar != null
                                  ? NetworkImage(marks[i].poster!.avatar!)
                                  : const AssetImage("assets/avatar.png") as ImageProvider<Object>,
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Container(
                                  decoration: const BoxDecoration(
                                color: Palette.scaffold,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: TextSpan(text: marks[i].poster!.name,
                                                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = (){
                                                  //TODO: Implement the redirect to user profile

                                                      }
                                                )
                                            ),
                                            const SizedBox(height: 10,),
                                            RichText(
                                                text: TextSpan(text: marks[i].created,
                                                    style: const TextStyle(fontSize: 10, color: Colors.black),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = (){

                                                      }
                                                )
                                            ),
                                            const SizedBox(height: 10,),

                                            RichText(
                                                text: TextSpan(text: marks[i].markContent,
                                                  style: const TextStyle(fontSize: 14, color: Colors.black),
                                                )
                                            ),

                                            const SizedBox(height: 10,),
                                          ],
                                        ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          RichText(
                                              text: TextSpan(text: "Like",
                                                  style: const TextStyle(fontSize: 12, color: Colors.black),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = (){
                                                      //TODO: Implement the redirect to user profile

                                                    }
                                              )
                                          ),
                                          const SizedBox(width: 15,),
                                          RichText(
                                              text: const TextSpan(text: "Reply",
                                                style: TextStyle(fontSize: 12, color: Colors.black),
                                              )
                                          ),
                                          const SizedBox(width: 15,),
                                          RichText(
                                              text: TextSpan(text: "Report",
                                                  style: const TextStyle(fontSize: 12, color: Colors.black),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = (){

                                                    }
                                              )
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      RepliesBox(comments: marks[i].comments)
                    ],
                  ),
                )
            ],
          ),
        ),
      );
  }
  void showReplyComments(List<Comment> replyComments) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Display reply comments here
              for (var comment in replyComments)
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comment.poster.avatar!) ?? AssetImage("assets/avatar.png") as ImageProvider,
                  ),
                  title: Text(comment.poster.name!),
                  subtitle: Text(comment.content),
                ),
            ],
          ),
        );
      },
    );
  }


}

