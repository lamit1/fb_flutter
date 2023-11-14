import 'package:fb_app/screens/home_screen.dart';
import 'package:fb_app/screens/loading_screen.dart';
import 'package:fb_app/screens/login_screens/otp_screen.dart';
import 'package:fb_app/services/api_services.dart';
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
                                  LoginButtonPressed(email: email, password: password),
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
        } else if (state is LoginSuccess) {
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, "/otp", arguments: [_emailController.text]);
          });
          return const Scaffold(body: Text("Login success"));
        } else if (state is LoginFailure) {
          return Scaffold(body: Text('Login Failed: ${state.error}'),);
        } else {
          return Container();
        }
      },
    );
  }
}