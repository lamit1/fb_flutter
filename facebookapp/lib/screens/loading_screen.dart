import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Your loading indicator
            SizedBox(height: 16), // Add some spacing
            Text("Loading..."), // Optional text message
          ],
        ),
      ),
    );
  }
}
