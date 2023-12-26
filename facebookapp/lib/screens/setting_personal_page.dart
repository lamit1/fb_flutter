import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/screens/edit_personal_page.dart';
import 'package:fb_app/screens/search_personal_page.dart';
import 'package:flutter/material.dart';


class SettingPersonalPage extends StatefulWidget {
  final UserInfo userInfo;
  const SettingPersonalPage({super.key, required this.userInfo});

  @override
  State<SettingPersonalPage> createState() => _SettingPersonalPageState();
}

class _SettingPersonalPageState extends State<SettingPersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt trang cá nhân'),
      ),
      body: Column(children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditPersonalPage(
                        userInfo: widget.userInfo,
                      )),
                )
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.black45,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Chỉnh sửa trang cá nhân',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchPersonalPage()),
                )
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.black45,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Tìm kiếm trên trang cá nhan',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ]),
    );
  }
}
