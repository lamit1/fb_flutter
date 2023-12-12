import 'package:fb_app/bloc/sign_up/sign_up_bloc.dart';
import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/screens/forgot_password_screen.dart';
import 'package:fb_app/screens/home_screen.dart';
import 'package:fb_app/screens/loading_screen.dart';
import 'package:fb_app/screens/login_screens/change_info.dart';
import 'package:fb_app/screens/login_screens/login_screen.dart';
import 'package:fb_app/screens/login_screens/otp_screen.dart';
import 'package:fb_app/screens/sign_up_screens/sign_up_screen.dart';
import 'package:fb_app/screens/sign_up_screens/type_password_screen.dart';
import 'package:fb_app/screens/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fb_app/screens/add_post_screen.dart';
import 'bloc/login/login_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook Login',
      debugShowCheckedModeBanner: false,
      initialRoute: "/add_post_screen",
      theme: ThemeData(
        primaryColor: Palette.facebookBlue,
      ),
      // routes: {
      //   "/login": (BuildContext context) =>
      //       BlocProvider(create: (context) => LoginBloc(), child: LoginPage()),
      //   "/home": (BuildContext context) => HomeScreen(),
      //   "/sign_up": (BuildContext context) => SignUpScreen(),
      //   "/otp": (BuildContext context) => OTPScreen(),
      //   "/loading": (BuildContext context) => LoadingScreen(),
      //   "/type_password": (BuildContext context) => PasswordScreen(),
      //   "/forgot_password": (BuildContext context) => ForgotPasswordScreen(),
      //   "/change_info": (BuildContext context) => ChangeInfoScreen(),
      //   "/add_post_screen": (BuildContext context) => AddPostScreen(),
      // },
      routes: {
        // "/add_post_screen": (BuildContext context) => AddPostScreen(),
        "/add_post_screen": (BuildContext context) => VideoScreen(),
      },
    );
  }
}
