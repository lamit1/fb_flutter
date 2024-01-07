// ignore_for_file: use_build_context_synchronously

import 'package:fb_app/screens/sign_up_screens/sign_up_success_screen.dart';
import 'package:flutter/material.dart';

import '../../services/api/auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? code = await Auth().changePassword(_oldPasswordController.text,_newPasswordController.text);

      Navigator.pop(context);
      if(code == "1000") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: Text('Success'),
              content: Text('Change password successfully'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              title: Text('Error'),
              content: Text('Change password unsuccessfully'),
            );
          },
        );
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    // Check if the password contains special characters
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must not contain special characters';
    }

    // Check if the password length is between 6 and 10 characters
    if (value.length < 6 || value.length > 10) {
      return 'Password must be between 6 and 10 characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Previous Password',
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _confirmNewPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      hintText: 'Re-enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 50),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
