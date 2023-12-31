import 'package:flutter/material.dart';

class FacebookSearchScreen extends StatefulWidget {
  const FacebookSearchScreen({Key? key}) : super(key: key);

  @override
  State<FacebookSearchScreen> createState() => _FacebookSearchScreenState();
}

class _FacebookSearchScreenState extends State<FacebookSearchScreen> {
  String currentQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearch(onQuerySelected: (query) {
                  setState(() {
                    currentQuery = query;
                  });
                }),
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Search content for: $currentQuery',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  final Function(String)? onQuerySelected;

  CustomSearch({this.onQuerySelected});

  List<String> facebookSearchList = [
    'People',
    'Pages',
    'Groups',
    'Photos',
    'Videos',
    'Events',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];

    for (var category in facebookSearchList) {
      if (category.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(category);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (onQuerySelected != null) {
              onQuerySelected!(matchQuery[index]);
            }
            close(context, matchQuery[index]);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              matchQuery[index],
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
