import 'package:flutter/material.dart';

class FacebookSearchScreen extends StatefulWidget {
  const FacebookSearchScreen({Key? key}) : super(key: key);

  @override
  State<FacebookSearchScreen> createState() => _FacebookSearchScreenState();
}

class _FacebookSearchScreenState extends State<FacebookSearchScreen> {
  bool _showSuggestionWidget = false;
  bool _showResultWidget = false;

  TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [
    'John Doe',
    'Jane Smith',
    'Mark Johnson',
    'Sarah Brown',
    'Michael Lee',
    // Add more suggestions as needed
  ];

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
        prefixIcon: Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
          },
        ),
      ),
      onChanged: (value) {
        setState(() {
          _suggestions = _getFilteredSuggestions(value);
        });
      },
      onSubmitted: (value) {
        _performSearch(value);
      },
      onTap: (){
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
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_suggestions[index]),
            onTap: () {
              _performSearch(_suggestions[index]);
            },
          );
        },
      ),
    )
        : SizedBox.shrink(); // Return an empty widget when _showSuggestions is false
  }

  List<String> _getFilteredSuggestions(String query) {
    List<String> filteredSuggestions = _suggestions
        .where((suggestion) =>
        suggestion.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (!_suggestions.contains(query)) {
      filteredSuggestions.insert(0, query);
    }

    return filteredSuggestions;
  }

  void _performSearch(String query) {
    // Implement your search logic here
    print('Performing search for: $query');
    // You can navigate to another screen or update the UI as needed

    // Update the search bar text with the selected suggestion
    setState(() {
      _searchController.text = query;
      _showSuggestionWidget = false;
      _showResultWidget = true;
    });
  }


  Widget _buildSearchResults() {
    return _showResultWidget
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Results',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Posts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildPostList(),  // Display list of posts
        SizedBox(height: 16),
        Text(
          'Friends',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildFriendsList(),  // Display list of friends
      ],
    )
        : SizedBox.shrink(); // Return an empty widget when _showResult is false
  }

  Widget _buildPostList() {
    // Replace this with your logic to display posts
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Replace the following with your post items
          ListTile(
            title: Text('Post 1'),
          ),
          ListTile(
            title: Text('Post 2'),
          ),
          // Add more post items as needed
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    // Replace this with your logic to display friends
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
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
