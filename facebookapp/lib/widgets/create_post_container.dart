import 'package:fb_app/models/post_model.dart';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/screens/add_post_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../screens/profile_screen.dart';


class CreatePostContainer extends StatefulWidget {
  final UserInfo currentUser;

  Function loadPosts;

  CreatePostContainer({super.key, required this.currentUser, required this.loadPosts});

  @override
  State<CreatePostContainer> createState() => _CreatePostContainerState();
}

class _CreatePostContainerState extends State<CreatePostContainer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to the profile screen when tapped
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(id: widget.currentUser.id!, type:'1')));
                  },
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: NetworkImage(
                      widget.currentUser.avatar ?? "assets/avatar.png",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddPostScreen(user: widget.currentUser, onPostAdded: widget.loadPosts)),
                      ).then((_) => {
                        widget.loadPosts(),
                        print('loadPosts called from CreatePostContainer')
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "What's on your mind?",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                          prefixIcon: Icon(Icons.edit),
                        ),
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        // Prevents keyboard from showing up
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AddPostScreen(user: widget.currentUser, onPostAdded: widget.loadPosts,)),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 10.0,
            thickness: 0.5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => {
                        if(widget.currentUser != null) {
                          Navigator.push(context,
                            MaterialPageRoute (
                                builder: (BuildContext context) => AddPostScreen(user: widget.currentUser, onPostAdded: widget.loadPosts,)),
                          )
                        }
                    },
                      child: const Row(
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Icon(Icons.add, color: Colors.white,),
                          SizedBox(width: 15.0, height: 5.0,),
                          Text("Create Post",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => {
                        Navigator.push(context,
                        MaterialPageRoute(
                        builder: (BuildContext context) =>
                        AddPostScreen(user: widget.currentUser, onPostAdded: widget.loadPosts,)),
                        )
                      },
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
