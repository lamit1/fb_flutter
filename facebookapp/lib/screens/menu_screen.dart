import 'package:fb_app/screens/change_password.dart';
import 'package:fb_app/screens/profile_screen.dart';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/screens/push_setting_screen.dart';
import 'package:fb_app/services/api/profile.dart';
import 'package:fb_app/screens/add_coins.dart';
import 'package:fb_app/widgets/menu_item.dart';
import 'package:fb_app/screens/block_screen.dart';
import 'package:flutter/material.dart';
import 'package:fb_app/core/pallete.dart';
import 'package:flutter/widgets.dart';
import 'package:fb_app/services/api/auth.dart';
import 'package:logger/logger.dart';
import './profile_screen.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({super.key, required this.uid});

  String? uid;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late UserInfo userInfo = UserInfo();

  void getData() async {
    UserInfo user = await ProfileAPI().getUserInfo(widget.uid!);
    setState(() {
      userInfo = user;
    });
  }

  void reloadData() {
    getData();
  }

  @override
  void initState() {
    super.initState;
    getData();
  }

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
        showTimedAlertDialog('Success', 'Friend request accepted successfully.',
            Duration(seconds: 2));
      }
    } catch (error) {
      Logger().d('Error Accept: $error');
      showTimedAlertDialog(
          'Error', 'Failed to accept friend request.', Duration(seconds: 2));
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
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            if (index == 0) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the profile screen when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen(id: widget.uid!, type: '1')),
                  );
                },
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                            userInfo.avatar != null
                              ? userInfo.avatar!
                              : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png'
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userInfo.username != null ? userInfo.username! : '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 24),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 15.0,
                                        backgroundImage: NetworkImage(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7rjB8BcKmkkifnTHKogjZ3WxZItOmGgRItiyH8g9ph4xbppnClyAJg5D7WyO6Rys-OBo&usqp=CAU'
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        '${userInfo.coins ?? '0'} coins',
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AddCoins(userInfo: userInfo, context: context, reloadData: reloadData,)),
                                      );
                                    },
                                    child: Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Palette.facebookBlue,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            if (index == 1) {
              return MenuItem(
                icon: Icons.settings,
                text: "Settings",
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const PushSettingPage(key: PageStorageKey('settingScreen'))),
                  );
                },
              );
            }
            if (index == 2) {
              return MenuItem(
                icon: Icons.list,
                text: "List Blocks",
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const BlockScreen(key: PageStorageKey('blockScreen'))),
                  );
                },
              );
            }
            if (index == 3) {
              return MenuItem(
                icon: Icons.change_circle,
                text: "Change Password",
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(
                            key: PageStorageKey('changePasswordScreen'))),
                  );
                },
              );
            }
            if (index == 4) {
              return MenuItem(
                icon: Icons.logout,
                text: "Logout",
                function: () {
                  _logOut();
                  Navigator.of(context).pushReplacementNamed("/login");
                },
              );
            }
            return Container();
          }, childCount: 10))
        ],
      ),
    );
  }
}
