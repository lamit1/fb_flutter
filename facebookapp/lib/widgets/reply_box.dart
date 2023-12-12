import 'package:flutter/material.dart';

import '../models/cmt_model.dart';

class RepliesBox extends StatefulWidget {
  final List<Comment>? comments;

  RepliesBox({required this.comments});

  @override
  _RepliesBoxState createState() => _RepliesBoxState();
}

class _RepliesBoxState extends State<RepliesBox> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    if (widget.comments == null || widget.comments!.isEmpty) {
      return Container();
    }
    if (!showReplies) {
      return GestureDetector(
        onTap: () {
          setState(() {
            showReplies = !showReplies;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            showReplies
                ? "Hide replies"
                : "View more ${widget.comments!.length - 2} replies...",
            style: const TextStyle(fontSize: 12, color: Colors.blue),
          ),
        ),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < widget.comments!.length; i++)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        NetworkImage(widget.comments![i].poster!.avatar!)),
                const SizedBox(width: 10)!,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comments![i].poster!.name!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.comments![i].content!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                showReplies = !showReplies;
              });
            },
            child: const Text("Hide replies",
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}
