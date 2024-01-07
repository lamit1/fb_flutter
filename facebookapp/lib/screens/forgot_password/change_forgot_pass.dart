import 'package:fb_app/screens/sign_up_screens/sign_up_success_screen.dart';
import 'package:flutter/material.dart';

import '../../services/api/auth.dart';

class ChangeForgotPasswordScreen extends StatefulWidget {
  const ChangeForgotPasswordScreen({super.key});

  @override
  State<ChangeForgotPasswordScreen> createState() => _ChangeForgotPasswordScreenState();
}

class _ChangeForgotPasswordScreenState extends State<ChangeForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  late String email;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Passwords are valid, continue sign-up process
      // You can add your logic here
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: SizedBox(
              width: 50.0, // Set the width to your desired size
              height: 50.0, // Set the height to your desired size
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0), // Adjust the radius as needed
              ),
            ),
          )
      );
      String? otp = await Auth().getVerifyOTP(email);
      String? code = await Auth().resetPassword(email,_passwordController.text,otp!);
      Navigator.pop(context);
      if(code == "1000") {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Change password successfully"),
              content:
              const Text("You have restored your password"),
              actions: [
                TextButton(
                    onPressed: (){Navigator.pop(context, 'OK');},
                    child: const Text("OK"))
              ],
            )
        );
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Failed"),
              content:
              const Text("Can not change password"),
              actions: [
                TextButton(
                    onPressed: (){Navigator.pop(context, 'OK');},
                    child: const Text("OK"))
              ],
            )
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
    final dynamic data = ModalRoute.of(context)?.settings.arguments;
    email = data[0];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Forgot Password'),
      ),
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
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                    controller: _confirmPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                      if (value != _passwordController.text) {
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
