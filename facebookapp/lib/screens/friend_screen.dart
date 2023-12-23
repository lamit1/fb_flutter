import 'package:fb_app/models/friend_model.dart';
import 'package:fb_app/services/api/friend.dart';
import 'package:fb_app/widgets/friend_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FriendScreen extends StatefulWidget {
  final String? uid;

  const FriendScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController =
  ScrollController(keepScrollOffset: true);
  late List<Friend> friend;
  late List<Friend> reqFriend;
  late List<Friend> sugFriend;
  int visibleFriendsCount = 5;

  void loadMoreFriends() {
    setState(() {
      visibleFriendsCount += 5;
    });
  }

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    friend = [];
    reqFriend = [];
    sugFriend = [];
    loadFriends();
    loadReqFriends();
    loadSugFriends();
    // Change tab
    _tabController!.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabChange);
    _tabController!.dispose();
    super.dispose();
  }

  void loadFriends() async {
    try {
      List<Friend>? fetchedFriends = await FriendAPI().getUserFriends(
        '0',
        '100',
        widget.uid!,
      );
      if (fetchedFriends != null) {
        setState(() {
          friend = fetchedFriends;
        });
      }
    } catch (error) {
      Logger().d('Error loading friends: $error');
    }
  }

  void loadReqFriends() async {
    try {
      List<Friend>? fetchedReqFriends = await FriendAPI().getRequestedFriends(
        '0',
        '100',
      );
      if (fetchedReqFriends != null) {
        setState(() {
          reqFriend = fetchedReqFriends;
        });
      }
    } catch (error) {
      Logger().d('Error loading reqFriends: $error');
    }
  }

  void loadSugFriends() async {
    try {
      List<Friend>? fetchedSugFriends =
      await FriendAPI().getSuggestedFriends(
        '0',
        '100',
      );
      if (fetchedSugFriends != null) {
        setState(() {
          sugFriend = fetchedSugFriends;
        });
      }
    } catch (error) {
      Logger().d('Error loading friends: $error');
    }
  }

  void reloadFriendList() {
    // Reload the list of friends here
    loadSugFriends();
    loadReqFriends();
    loadFriends();
  }

  void _handleTabChange() {
    setState(() {
      visibleFriendsCount = 5;
    });

    _scrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: Colors.white38,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0.0, 1.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++)
                  Expanded(
                    child: Container(
                      height: 40.0, // Adjust the height as needed
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(18.0),
                        color: _tabController?.index == i ? Colors.lightBlue : Colors.white,
                      ),
                      child: InkWell(
                        onTap: () {
                          _tabController?.animateTo(i);
                        },
                        child: Center(
                          child: Text(
                            i == 0 ? 'Lời mời' : (i == 1 ? 'Gợi ý' : 'Bạn bè'),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: _tabController?.index == i ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestFriendsList(reqFriend, 'request'),
                _buildSuggestedFriendsList(sugFriend, 'suggest'),
                _buildFriendsList(friend, 'friend'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestFriendsList(List<Friend> friends, String tag) {
    int maxVisibleFriendCount = friends.length;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              if (index >= friends.length) {
                return Container();
              }
              if (index < visibleFriendsCount) {
                return FriendCard(friend: friends[index], tag: tag, reloadFriendList: reloadFriendList);
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
            childCount:
            visibleFriendsCount + 1, // Add 1 for the "Load More" button
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedFriendsList(List<Friend> friends, String tag) {
    int maxVisibleFriendCount = friends.length;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              if (index >= friends.length) return Container();
              if (index < visibleFriendsCount) {
                return FriendCard(friend: friends[index], tag: tag, reloadFriendList: reloadFriendList);
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
            childCount:
            visibleFriendsCount + 1, // Add 1 for the "Load More" button
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsList(List<Friend> friends, String tag) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return FriendCard(friend: friends[index], tag: tag, reloadFriendList: reloadFriendList);
            },
            childCount: friends.length,
          ),
        ),
      ],
    );
  }
}
