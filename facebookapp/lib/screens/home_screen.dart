
import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/screens/friend_screen.dart';
import 'package:fb_app/screens/notifications_screen.dart';
import 'package:fb_app/screens/post_screen.dart';
import 'package:fb_app/screens/search_screen.dart';
import 'package:fb_app/screens/video_screen.dart';
import 'package:fb_app/widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  Key _postScreenKey = UniqueKey();

  void _resetPostScreen() {
    setState(() {
      _postScreenKey = UniqueKey(); // Generate a new key
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String? uid = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title:const Text(
          'Facebook',
          style: TextStyle(
            color: Palette.facebookBlue,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleButton(icon: Icons.search, iconSize: 25.0,
                onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacebookSearchScreen()));
            }),
          ),
        ],
      ),
      body: PageView(
          controller: _pageController,
          children: [
            PostScreen(key: _postScreenKey, uid: uid, ),
            FriendScreen(key: PageStorageKey('friendScreen'), uid: uid),
            VideoScreen(key: _postScreenKey, uid: uid,),
            NotificationScreen(key: PageStorageKey('notificationScreen'), uid: uid),
            MenuScreen(key: PageStorageKey('menuScreen'), uid:uid),
          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Allows more than 3 items
        currentIndex: _selectedIndex,
        onTap: (index){
          if (_selectedIndex != 0 && index == 0) {
            _resetPostScreen(); // Call this when navigating back to PostScreen
          }
          setState(() {
            _selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        }, // Function to handle item taps
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
