import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/mark_cmt_model.dart';
import 'package:fb_app/models/post_detail_model.dart';
import 'package:fb_app/services/api/block.dart';
import 'package:fb_app/services/api/comment.dart';
import 'package:fb_app/widgets/comment_sheet.dart';
import 'package:fb_app/widgets/reply_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/cmt_model.dart';
import '../models/user_info_model.dart';
import '../models/user_model.dart';
import '../services/api/profile.dart';
import '../utils/converter.dart';

class CommentBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final String? id;
  final String? uid;
  final Function updateMark;
  const CommentBottomSheet(
      {Key? key, required this.scrollController, this.id, this.uid, required this.updateMark})
      : super(key: key);

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  String? selectedSortOption = "all";
  final _key = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  late List<MarkComments>? marks = [];
  bool loading = true;
  String? isReplying = "-1";
  UserInfo user = UserInfo();
  late String userMarkType;
  late FocusNode commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadComments();
    _loadUserInfo();
    commentFocusNode.addListener(() {
      if (!commentFocusNode.hasFocus) {
        setState(() {
          isReplying = "-1";
        });
      }
    });
  }

  void _loadUserInfo() async {
    try {
      UserInfo userInfo = await ProfileAPI().getUserInfo(widget.uid!);
      setState(() {
        user = userInfo;
      });
    } catch (error) {
      Logger().d('Error loading user info: $error');
    }
  }

  Future<void> _loadComments() async {
    try {
      List<MarkComments>? marksData =
          await CommentAPI().getMarkComment(widget.id!, "0", "10");
      print("MARK DATA: $marksData");
      if (marksData != null) {
        MarkComments userMark = marksData.firstWhere((mark) => mark.poster!.id == widget.uid);
        setState(() {
          userMarkType = userMark.typeOfMark!;
          marks = marksData;
        });
      }
      setState(() {
        loading = false;
      });

    } catch (error) {
      // Handle error if necessary
      print("Error loading comments: $error");
    }
  }

  void setType(String markType) {
    setState(() {
      userMarkType = markType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Scaffold(
              body: CommentBox(
                userImage: CommentBox.commentImageParser(
                    imageURLorPath: user.avatar ?? "assets/avatar.png"),
                labelText:
                    isReplying == "-1" ? 'Write a mark...' : 'Reply a mark...',
                errorText: 'Comment cannot be blank',
                withBorder: false,
                focusNode: commentFocusNode,
                currentMarkType: userMarkType,
                setType: setType,
                sendButtonMethod: () async {
                  if (_key.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    List<MarkComments> newMarks = [];
                    if (isReplying != "-1") {
                      newMarks = await CommentAPI().setMarkComment(widget.id!,
                          commentController.text, "0", "10", isReplying!, userMarkType);
                    } else {
                      newMarks = await CommentAPI().setMark(
                          widget.id!, commentController.text, "0", "10", userMarkType);
                    }
                    setState(() {
                      marks = newMarks;
                      isReplying = "-1";
                    });
                    widget.updateMark();
                    commentController.clear();
                  } else {
                    print("Not validated");
                  }
                },
                formKey: _key,
                commentController: commentController,
                textColor: Colors.black,
                sendWidget: const Icon(Icons.send_sharp,
                    size: 30, color: Palette.facebookBlue),
                child: commentChild(marks),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
            color: Palette.facebookBlue,
          ));
  }

  Widget commentChild(List<MarkComments>? marks) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    value: selectedSortOption,
                    items: const [
                      DropdownMenuItem(
                        value: 'nearest',
                        child: Text('Sort by Nearest Time'),
                      ),
                      DropdownMenuItem(
                        value: 'latest',
                        child: Text('Sort by Latest Time'),
                      ),
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All comments'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSortOption = value!;
                        // Call a method to sort comments based on the selected option
                        // For example: sortComments();
                      });
                    },
                  ),
                ],
              ),
            ),
            if (marks == null || marks.isEmpty && loading == false)
              const SizedBox(
                width: double.infinity,
                height: 500,
                child: Center(
                  child: Text(
                    "There is no comment in this post!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Palette.facebookBlue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              for (var i = 0; i < marks.length; i++)
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 15.0, 2.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: marks[i].poster!.avatar != null
                                ? NetworkImage(marks[i].poster!.avatar!)
                                : const AssetImage("assets/avatar.png")
                                    as ImageProvider<Object>,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Palette.scaffold,
                                // Why the border is error
                                border: (marks[i].id == isReplying)
                                    ? Border.all(
                                        color: Palette.facebookBlue,
                                        width: 1.5,
                                      )
                                    : null,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: "${marks[i].poster!.name}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    //TODO: Implement the redirect to user profile
                                                  },
                                              ),
                                            ),
                                            Icon(marks[i].typeOfMark == "0" ? Icons.thumb_down : Icons.thumb_up, color: Palette.facebookBlue,)
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: convertTimestamp(
                                                marks[i].created!),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {},
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: marks[i].markContent,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        widget.uid! != marks[i].poster!.id!
                                            ? RichText(
                                                text: TextSpan(
                                                  text: "Reply",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Palette.facebookBlue,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          setState(() {
                                                            isReplying =
                                                                marks[i].id ??
                                                                    "-1";
                                                          });
                                                          commentFocusNode
                                                              .requestFocus();
                                                        },
                                                ),
                                              )
                                            : Container(),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        if (widget.uid! != marks[i].poster!.id!) RichText(
                                                text: TextSpan(
                                                  text: "Block",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.deepOrange,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return  AlertDialog(
                                                                  title: Text(
                                                                      "Block \"${marks[i].poster!.name!}\"",
                                                                  ),
                                                                  content: Text(
                                                                      "Are you sure to block \"${marks[i].poster!.name!}\""),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                                  await BlockAPI()
                                                                                  .setBlock(
                                                                                  marks[i]
                                                                                      .poster!
                                                                                      .id!);
                                                                              _loadComments();
                                                                              Navigator.of(context).pop();
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
                                                ),
                                              ) else Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      RepliesBox(comments: marks[i].comments),
                    ],
                  ),
                ),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Display reply comments here
              for (var comment in replyComments)
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(comment.poster!.avatar!),
                  ),
                  title: Text(comment.poster!.name!),
                  subtitle: Text(comment.content!),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose the FocusNode when the widget is disposed
    commentFocusNode.dispose();
    super.dispose();
  }
}
