import 'package:fb_app/core/pallete.dart';
import 'package:flutter/material.dart';

class SignUpSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Palette.facebookBlue,
              size: 100.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Sign Up Successful!',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Palette.facebookBlue
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the home screen or any other screen as needed
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
