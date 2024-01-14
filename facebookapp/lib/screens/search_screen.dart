import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/models/image_model.dart';
import 'package:fb_app/screens/profile_screen.dart';
import 'package:fb_app/widgets/search_post_widget.dart';
import 'package:flutter/material.dart';

import '../models/saved_search_model.dart';
import '../models/search_model.dart';
import '../models/user_search_model.dart';
import '../services/api/search.dart';
import '../services/storage.dart';

class FacebookSearchScreen extends StatefulWidget {
  FacebookSearchScreen({Key? key}) : super(key: key);

  @override
  State<FacebookSearchScreen> createState() => _FacebookSearchScreenState();
}

class _FacebookSearchScreenState extends State<FacebookSearchScreen> {
  bool _showSuggestionWidget = true;
  bool _showResultWidget = false;
  List<SavedSearch?> _suggestions = [];
  String? uid = "";

  List<SearchPost> _searchedPosts = [];
  List<SearchUser> _searchedUsers = [];

  @override
  void initState() {
    getSavedSearch();
  }

  void getSavedSearch() async {
    List<SavedSearch>? newSavedList =
        await SearchAPI().getSavedSearch('0', '10');
    if (newSavedList != null) {
      setState(() {
        _suggestions = newSavedList;
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSuggestions(),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            String keyword = _searchController.text;
            List<SearchPost>? newSearchs =
                await SearchAPI().search(keyword, '0', '10');
            List<SearchUser>? newSearchedUserList =
                await SearchAPI().searchUser(keyword, '0', '5');
            if (newSearchedUserList != null) {
              setState(() {
                _searchedUsers = newSearchedUserList;
              });
            }
            if (newSearchs != null) {
              setState(() {
                _searchedPosts = newSearchs;
                _showSuggestionWidget = false;
                _showResultWidget = true;
                getSavedSearch();
              });
            }
          },
        ),
      ),
      onChanged: (value) {
        setState(() {
          // _suggestions = _getFilteredSuggestions(value);
        });
      },
      onSubmitted: (value) {
        _performSearch();
      },
      onTap: () {
        setState(() {
          _showSuggestionWidget = true;
          _showResultWidget = false;
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return _showSuggestionWidget
        ? Flexible(
          child: ListView.separated(
            itemCount: _suggestions.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_suggestions[index]!.keyword!),
                trailing: GestureDetector(
                    onTap: () async {
                      await SearchAPI()
                          .delSavedSearch(_suggestions[index]!.id!, '0');
                      setState(() {
                        _suggestions.removeWhere(
                            (item) => item!.id == _suggestions[index]!.id);
                      });
                    },
                    child: const Icon(Icons.close)),
                onTap: () {
                  _searchController.text = _suggestions[index]!.keyword!;
                  setState(() {
                    _showSuggestionWidget = false;
                  });
                },
              );
            },
          ),
        )
        : const SizedBox
            .shrink(); // Return an empty widget when _showSuggestions is false
  }

  // List<String> _getFilteredSuggestions(String query) {
  //   List<String> filteredSuggestions = _suggestions
  //       .where((suggestion) =>
  //           suggestion.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //   List<String>? stringSuggestions = _suggestions.map((suggestion) => {
  //     return suggestion.keyword!;
  //   })
  //   if (!_suggestions.contains(query)) {
  //     filteredSuggestions.insert(0, query);
  //   }
  //
  //   return filteredSuggestions;
  // }

  void _performSearch() {
    // You can navigate to another screen or update the UI as needed

    // Update the search bar text with the selected suggestion
    setState(() {
      _showSuggestionWidget = false;
      _showResultWidget = true;
    });
  }

  Widget _buildSearchResults() {
    return _showResultWidget
        ? Flexible(
            // Wrap with Flexible
            child: ListView(
              children: [
                const Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Peoples',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildFriendsList(),
                const SizedBox(height: 8),
                const Text(
                  'Posts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildPostList(),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildPostList() {
    return _searchedPosts.isNotEmpty
        ? Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _searchedPosts.length,
            itemBuilder: (context, index) {
              return SearchPostWidget(
                searchPost: _searchedPosts[index],
                uid: uid ?? '1', // Assuming uid is non-null
                loadPosts: () {
                  /* ... */
                },
                addMark: (String id, String mark) {
                  /* ... */
                },
              );
            },
          ),
        )
        : const Center(
            child: Text('No posts found'),
          );
  }

  Widget _buildFriendsList() {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true, // Add this
        physics: const NeverScrollableScrollPhysics(), // Add this
        itemCount: _searchedUsers.length,
        itemBuilder: (context, index) {
          SearchUser user = _searchedUsers[index];
          return Card(
            child: ListTile(
              leading: user.avatar != null
                  ? CircleAvatar(backgroundImage: NetworkImage(user.avatar!))
                  : null,
              title: Text(user.username ?? 'Unknown'),
              subtitle: Text(user.sameFriends == "1" ? "Friend" : 'Stranger'),
              trailing: GestureDetector(
                onTap: ()=>navigateToUserProfile(user.id, user.sameFriends),
                child: const Icon(Icons.person, color: Palette.facebookBlue,),
              ),
            ),
          );
        },
      ),
    );
  }

  void navigateToUserProfile(String? id, String? sameFriend) {
    if(sameFriend == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            id: id!,
            type: '2',
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            id: id!,
            type: '4',
          ),
        ),
      );
    }

  }
}
