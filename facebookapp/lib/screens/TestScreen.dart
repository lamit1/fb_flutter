import 'package:fb_app/services/api/profile.dart';
import 'package:fb_app/services/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: ElevatedButton(
        onPressed: () async {
          var token =
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiZGV2aWNlX2lkIjoic3RyaW5nIiwiaWF0IjoxNzAwOTE3MTY1fQ.aa1w4m_goGm5odG5wxP_0hP7U4KPxR83R0B6J_-uCoY";
          Storage().saveToken(token);
          var storedToken = await Storage().getToken();
          var response = await ProfileAPI().getUserInfo("0");
      }, child: Text("Test get_user"),
      ),
    );
  }
}
