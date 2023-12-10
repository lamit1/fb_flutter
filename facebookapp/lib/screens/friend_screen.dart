import 'package:fb_app/models/friend_model.dart';
import 'package:fb_app/models/suggested_friends_model.dart';
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
  late List<SuggestedFriend> sugFriend;
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
      List<SuggestedFriend>? fetchedSugFriends =
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
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0.0, 1.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  child: Text(
                    'Lời mời',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Selected label color
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Gợi ý',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Unselected label color
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Bạn bè',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Unselected label color
                    ),
                  ),
                ),
              ],
              labelColor: Colors.white,
              // Selected label color
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              // Unselected label color
              indicator: const BoxDecoration(
                color:
                Colors.lightBlue, // Color for the selected tab's background
              ),
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
                return FriendCard(friend: friends[index], tag: tag);
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

  Widget _buildSuggestedFriendsList(List<SuggestedFriend> friends, String tag) {
    int maxVisibleFriendCount = friends.length;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              if (index >= friends.length) return Container();
              if (index < visibleFriendsCount) {
                Friend friend = Friend(
                  id: friends[index].userId,
                  username: friends[index].username,
                  avatar: friends[index].avatar,
                  sameFriends: friends[index].sameFriends,
                  created: '',
                );
                return FriendCard(friend: friend, tag: tag);
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
              return FriendCard(friend: friends[index], tag: tag);
            },
            childCount: friends.length,
          ),
        ),
      ],
    );
  }
}
