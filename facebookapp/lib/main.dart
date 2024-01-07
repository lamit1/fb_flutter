import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/screens/change_forgot_pass.dart';
import 'package:fb_app/screens/forgot_password_screen.dart';
import 'package:fb_app/screens/home_screen.dart';
import 'package:fb_app/screens/loading_screen.dart';
import 'package:fb_app/screens/login_screens/change_info.dart';
import 'package:fb_app/screens/login_screens/login_screen.dart';
import 'package:fb_app/screens/login_screens/otp_screen.dart';
import 'package:fb_app/screens/profile_screen.dart';
import 'package:fb_app/screens/sign_up_screens/sign_up_screen.dart';
import 'package:fb_app/screens/sign_up_screens/type_password_screen.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/fcm_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/login/login_bloc.dart';
import 'models/notification_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessage().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Facebook Login',
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      theme: ThemeData(
        primaryColor: Palette.facebookBlue,
      ),
      routes: {
        "/login": (BuildContext context) =>
            BlocProvider(create: (context) => LoginBloc(), child: LoginPage()),
        "/home": (BuildContext context) => const HomeScreen(),
        "/sign_up": (BuildContext context) => const SignUpScreen(),
        "/otp": (BuildContext context) => const OTPScreen(),
        "/loading": (BuildContext context) => LoadingScreen(),
        "/type_password": (BuildContext context) => PasswordScreen(),
        "/forgot_password": (BuildContext context) => const ForgotPasswordScreen(),
        "/change_forgot_pass": (BuildContext context) => const ChangeForgotPasswordScreen(),
        "/change_info": (BuildContext context) => const ChangeInfoScreen(),
      },
    );
  }

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("12312312312312312312312312312");
      navigateBasedOnMessage(message.data);
    });
  }
}
