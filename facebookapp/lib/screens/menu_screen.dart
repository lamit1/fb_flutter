import 'package:fb_app/screens/change_password.dart';
import 'package:fb_app/screens/profile_screen.dart';
import 'package:fb_app/widgets/menu_item.dart';
import 'package:fb_app/screens/block_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fb_app/services/api/auth.dart';
import 'package:logger/logger.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({super.key, required this.uid});
  String? uid;
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  void showTimedAlertDialog(String title, String content, Duration duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(duration, () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  void _logOut() async {
    try {
      String? resp = await Auth().logOut();
      if (resp != '1000') {
        Logger().d('Accept Friend');
        showTimedAlertDialog('Success', 'Friend request accepted successfully.', Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Accept: $error');
      showTimedAlertDialog('Error', 'Failed to accept friend request.', Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _logOut();
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index == 0) return  MenuItem(icon: Icons.person, text: "Profile", function: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(id: widget.uid!, type: '1')),
                      );
                    },);
                    if (index == 1) return  MenuItem(icon: Icons.payment, text: "Deposit", function: (){},);
                    if (index == 2) return  MenuItem(icon: Icons.settings, text: "Settings", function: (){},);
                    if (index == 3) return  MenuItem(icon: Icons.list, text: "List Blocks", function: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlockScreen(key: PageStorageKey('blockScreen'))),
                      );
                    },);
                    if (index == 4) return  MenuItem(icon: Icons.history, text: "History", function: (){},);
                    if (index == 5) return  MenuItem(icon: Icons.change_circle, text: "Change Password", function: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePasswordScreen(key: PageStorageKey('changePasswordScreen'))),
                      );
                    },);
                    if (index == 6) {
                      return  MenuItem(icon: Icons.logout, text: "Logout",
                      function: (){
                      _logOut();
                      Navigator.of(context).pushReplacementNamed("/login");
                      },
                    );
                    }
                    return Container();
                  },
                  childCount: 10
              )
          )
        ],
      ),
    );
  }
}