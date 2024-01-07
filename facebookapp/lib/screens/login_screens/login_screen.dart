import 'package:fb_app/screens/home_screen.dart';
import 'package:fb_app/screens/loading_screen.dart';
import 'package:fb_app/screens/forgot_password/otp_forget_screen.dart';
import 'package:fb_app/services/api/auth.dart';
import 'package:fb_app/services/api/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/login/login_bloc.dart';
import '../../models/user_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Track password visibility
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginInitial) {
          return Scaffold(
            body: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 75),
                    Image.asset(
                      'assets/facebook_logo.jpg',
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Enter your email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter email';
                              }
                              if (!emailRegex.hasMatch(value!)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: Container(
                                child: IconButton(
                                  splashRadius: 20.0,
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Validation succeeded, process form data
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginButtonPressed(
                                  email: email, password: password),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/forgot_password");
                            // Add forgot password functionality
                          },
                          child: const Text('Forgot Password?'),
                        ),
                        const SizedBox(height: 10), // Add some spacing
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/sign_up");
                          },
                          child: const Text("Don't have an account? Sign up"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
          );
        } else if (state is LoginLoading) {
          return LoadingScreen();
        } else if (state is LoginChangeInfo) {
          Future.delayed(Duration.zero, () async {
            Navigator.pushReplacementNamed(context, "/change_info", arguments: [state.uid]);
          });
          return Scaffold(
            body: Center(
              child: Text("Has'nt set user info, please change your info!"),
            ),
          );
        } else if (state is LoginSuccess) {
          String uid = state.uid;
          // This will run after the current build cycle completes
          Future.delayed(Duration.zero, () async {
            try {
              String? response = await SettingAPI().setDevToken();
              if (response != null) {
                Navigator.pushReplacementNamed(context, "/home",
                    arguments: uid);
              } else {
                print('Response from setDevToken is null');
              }
            } catch (error) {
              // Handle the error scenario
              // Show a dialog or a snackbar to inform the user
              print('Error setting dev token: $error');
            }
          });
          // Return the scaffold
          return const Scaffold(
            body: Center(
              child: Text("Login success!"),
            ),
          );
        } else if (state is LoginFailure) {
          return Scaffold(
            body: Text('Login Failed: ${state.error}'),
          );
        } else if (state is LoginOTP) {
          Future.delayed(Duration.zero, () async {
            Navigator.pushReplacementNamed(context, "/otp",
                arguments: [_emailController.text, state.uid]);
          });
          return Scaffold(
            body: Center(
              child: Text("Redirect to OTP screen"),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
