import 'package:fb_app/main.dart';
import 'package:flutter/material.dart';
import 'package:fb_app/services/api/auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter email';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void showTimedAlertDialog(String title, String content, Duration duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(duration, () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      // Implement password reset logic here
      showDialog(
          context: context,
          builder: (_) => const Center(
            child: CircularProgressIndicator(),
          )
      );
      String? status_code = await Auth().getVerifyCode(email);
      if(status_code == '1000'){
        Navigator.pop(context);
        Navigator.pushNamed(context, "/otp_forgot_pass", arguments: [email]);
      }
      else{
        showTimedAlertDialog('Error', 'Email khong ton tai', const Duration(seconds: 2));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}