import 'package:fb_app/widgets/search_post_widget.dart';
import 'package:flutter/material.dart';

import '../models/saved_search_model.dart';
import '../models/search_model.dart';
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


  @override
  void initState() {
    getUID();
    getSavedSearch();
  }

  void getUID() async {
    String? uidFetched = await Storage().getUID();
    setState(() {
      uid = uidFetched;
    });
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
                      await SearchAPI().delSavedSearch(_suggestions[index]!.id!, '0');
                      setState(() {
                        _suggestions.removeWhere((item) => item!.id == _suggestions[index]!.id);
                      });
                    },
                      child: const Icon(Icons.close)
                  ),
                  onTap: () {
                    _performSearch();
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
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                'Friends',
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
              _buildPostList(), // Display list of posts
            ],
          )
        : const SizedBox
            .shrink(); // Return an empty widget when _showResult is false
  }

  Widget _buildPostList() {
    // Replace this with your logic to display posts
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          _searchedPosts.map((search) => SearchPostWidget(post: search));
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    // Replace this with your logic to display friends
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          // Replace the following with your friend items
          ListTile(
            title: Text('Friend 1'),
          ),
          ListTile(
            title: Text('Friend 2'),
          ),
          // Add more friend items as needed
        ],
      ),
    );
  }
}
