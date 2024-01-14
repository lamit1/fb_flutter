import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/services/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void showTimedAlertDialog(String title, String content, Duration duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(duration, () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(title),
          content: Text(
            content,
            style: TextStyle(color: Colors.red), // Set text color to red
          ),
        );
      },
    );
  }

  Future<bool> checkEmail(String email) async {
    try {
      String? emailExisted = await Auth().checkEmail(email);
      return emailExisted == '1';
    } catch (error) {
      Logger().d('Error checking email existence: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Please type your email to continue sign-up",
                        style: TextStyle(color: Palette.facebookBlue, fontSize: 26, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String email = _emailController.text;
                        bool emailExisted = await checkEmail(email);

                        if (emailExisted) {
                          showTimedAlertDialog('Error', 'This email is already registered.', Duration(seconds: 2));
                        } else {
                          // Proceed to the next step in the signup process
                          Navigator.pushNamed(context, "/type_password", arguments: [email]);
                        }
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 50)),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
