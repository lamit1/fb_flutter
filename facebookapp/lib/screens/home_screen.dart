
import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/screens/friend_screen.dart';
import 'package:fb_app/screens/notifications_screen.dart';
import 'package:fb_app/screens/post_screen.dart';
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
            child: CircleButton(icon: Icons.search, iconSize: 25.0, onPressed: () {
              //TODO: Implement Search
              print("Search is clicked");
            }),
          ),
        ],
      ),
      body: PageView(
          controller: _pageController,
          children: [
            PostScreen(key: const PageStorageKey('postScreen'), uid: uid, ),
            FriendScreen(key: const PageStorageKey('FriendScreen'), uid: uid, ),
            VideoScreen(key: const PageStorageKey('videoScreen'), uid: uid,),
            const NotificationScreen(key: PageStorageKey('notificationScreen')),
            const MenuScreen(key: PageStorageKey('menuScreen')),
          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Allows more than 3 items
        currentIndex: _selectedIndex,
        onTap: (index){
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
