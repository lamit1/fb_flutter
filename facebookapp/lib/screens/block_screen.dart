import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/friend_model.dart';
import 'package:fb_app/services/api/block.dart';
import 'package:fb_app/widgets/block_card.dart';
import 'package:fb_app/widgets/friend_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/user_model.dart';

class BlockScreen extends StatefulWidget {
  const BlockScreen({Key? key}) : super(key: key);

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  final ScrollController _scrollController =
  ScrollController(keepScrollOffset: true);
  late List<User> users;
  int visibleFriendsCount = 5;

  void loadMoreFriends() {
    setState(() {
      visibleFriendsCount += 5;
    });
  }

  @override
  void initState() {
    super.initState();
    users = [];
    loadListBlocks();
  }

  void loadListBlocks() async {
    try {
      List<User>? fetchedUsers = await BlockAPI().getListBlocks(
        '0',
        '100',
      );
      if (fetchedUsers != null) {
        setState(() {
          users = fetchedUsers;
        });
      }
    } catch (error) {
      Logger().d('Error loading users: $error');
    }
  }

  void reloadBlockList() {
    // Reload the list of friends here
    loadListBlocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _buildBlockedUsersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedUsersList() {
    int maxVisibleFriendCount = users.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Blocks'),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                if (index >= users.length) {
                  return Container();
                }
                if (index < visibleFriendsCount) {
                  return BlockCard(
                    user: users[index],
                    reloadBlockList: reloadBlockList,
                    context: context,
                  );
                } else if (index == visibleFriendsCount &&
                    index != maxVisibleFriendCount) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: loadMoreFriends,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(24.0), // Rounded corners
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Load More'),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      )
                    ],
                  );
                } else {
                  return Container(); // Empty container for other indexes
                }
              },
              childCount: visibleFriendsCount +
                  1, // Add 1 for the "Load More" button
            ),
          ),
        ],
      ),
    );
  }
}
