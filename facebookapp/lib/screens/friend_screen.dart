import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/widgets/friend_card.dart';
import 'package:flutter/material.dart';


class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  int visibleFriendsCount = 5;
  int maxVisibleFriendCount = 12;
  void loadMoreFriends() {
    setState(() {
      visibleFriendsCount+=5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              if (index < visibleFriendsCount) {
                return FriendCard(friend: User());
              } else if (index == visibleFriendsCount && index != maxVisibleFriendCount) {
                return Column(
                  children: [
                    FriendCard(friend: User()),
                    ElevatedButton(
                      onPressed: loadMoreFriends,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Load More Friends'),
                      ),
                    ),
                    const SizedBox(height: 10.0,)
                  ],
                );
              } else {
                return Container(); // Empty container for other indexes
              }
            },
            childCount: visibleFriendsCount + 1 , // Add 1 for the "Load More" button
          ),
        ),
      ],
    );
  }
}
