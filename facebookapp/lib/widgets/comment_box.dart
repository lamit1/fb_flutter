import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/widgets/comment_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CommentBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  CommentBottomSheet({super.key, required this.scrollController});
  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _key = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  List filedata = [
    {
      'name': 'Chuks Okwuenu',
      'pic': 'https://picsum.photos/300/30',
      'message': 'I love to code',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://www.adeleyeayodeji.com/img/IMG_20200522_121756_834_2.jpg',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'Tunde Martins',
      'pic': 'assets/img/userpic.jpg',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool',
      'date': '2021-01-01 12:00:00'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Scaffold(
        body: CommentBox(
          userImage: CommentBox.commentImageParser(imageURLorPath: "assets/avatar.png"), // Pass the filedata parameter
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
          child: commentChild(filedata),
        ),
      ),
    );
  }

  Widget commentChild(data,) {
    return SingleChildScrollView(
        controller: widget.scrollController,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (var i = 0; i < data.length; i++)
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
                              child: Image.network(data[i]['pic'])
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
                                                text: TextSpan(text: data[i]['name'],
                                                  style: const TextStyle(fontSize: 20, color: Colors.black),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = (){
                                                  //TODO: Implement the redirect to user profile

                                                      }
                                                )
                                            ),
                                            const SizedBox(height: 10,),
                                            RichText(
                                                text: TextSpan(text: data[i]['date'],
                                                    style: const TextStyle(fontSize: 10, color: Colors.black),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = (){

                                                      }
                                                )
                                            ),
                                            const SizedBox(height: 10,),

                                            RichText(
                                                text: TextSpan(text: data[i]['message'],
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
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: RichText(
                            text: TextSpan(
                              text: "View more 3 reply...",
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              recognizer: TapGestureRecognizer()..onTap = (){
                              // TODO: Implement add reply
                              }
                            ),

                        ),
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      );
  }


}

