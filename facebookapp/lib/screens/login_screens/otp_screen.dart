// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:fb_app/core/pallete.dart';
import 'package:fb_app/services/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  static const maxSeconds = 120;
  bool canSendOTP = true;
  int seconds = 0;
  Timer? timer;
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());

  void startTimer() {
    setState(() {
      seconds = maxSeconds;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => seconds--);
      if (seconds == 0) {
        setState(() {
          canSendOTP = true;
        });
        timer?.cancel();
      }
    });
  }


  // Function to get the complete 6-digit OTP
  String getOtp() {
    String otp = '';
    for (var controller in _controllers) {
      otp += controller.text;
    }
    return otp;
  }

  @override
  Widget build(BuildContext context) {
    final dynamic data = ModalRoute.of(context)?.settings.arguments;
    String email = data[0];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Please enter the 6-digit OTP sent to: $email',
                style: const TextStyle(
                    fontSize: 24,
                    color: Palette.facebookBlue,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      height: 40,
                      width: 40,
                      child: TextFormField(
                        controller: _controllers[index],
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                            _controllers[index].clear();
                          }
                        },
                        onSaved: (value) {},
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Builder(builder: (context) {
                          return ElevatedButton(
                            style: const ButtonStyle(
                              minimumSize:
                                  MaterialStatePropertyAll(Size(100, 50)),
                            ),
                            onPressed: () async {
                              // Get the complete 6-digit OTP
                              String otp = getOtp();
                              if (otp.length != 6) {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: const Text("Invalid OTP"),
                                          content: const Text(
                                              "Please provide 6-digits OTP"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'OK');
                                                },
                                                child: const Text("OK"))
                                          ],
                                        ));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (_) => const AlertDialog(
                                          content: SizedBox(
                                            width: 50.0,
                                            // Set the width to your desired size
                                            height: 50.0,
                                            // Set the height to your desired size
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  10.0), // Adjust the radius as needed
                                            ),
                                          ),
                                        ));
                                String? code = await Auth()
                                    .checkVerifyCode(email, otp);
                                Navigator.pop(context);
                                if (code == "1000") {
                                  Navigator.pushReplacementNamed(context, "/change_forgot_pass",
                                      arguments: [email]);
                                } else if (code == "9993") {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title:
                                                const Text("Wrong OTP number"),
                                            content: const Text(
                                                "Please enter the correct OTP number"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, 'OK');
                                                  },
                                                  child: const Text("OK"))
                                            ],
                                          ));
                                }
                              }
                            },
                            child: const Text('Verify OTP'),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: const ButtonStyle(
                              minimumSize:
                                  MaterialStatePropertyAll(Size(100, 50))),
                          onPressed: canSendOTP
                              ? () async {
                                  showDialog(
                                      context: context,
                                      builder: (_) => const AlertDialog(
                                            content: SizedBox(
                                              width: 50.0,
                                              // Set the width to your desired size
                                              height: 50.0,
                                              // Set the height to your desired size
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    10.0), // Adjust the radius as needed
                                              ),
                                            ),
                                          ));
                                  String? code = await Auth()
                                      .getVerifyCode(email.toString());
                                  Navigator.pop(context);
                                  if (code == "1000") {
                                    setState(() {
                                      canSendOTP = false;
                                    });
                                    startTimer();
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text("Error"),
                                              content: const Text(
                                                  "Some thing wrong has happened!"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'OK');
                                                    },
                                                    child: const Text("OK"))
                                              ],
                                            ));
                                  }
                                }
                              : null,
                          child: seconds > 0
                              ? Text("Wait $seconds to send OTP")
                              : const Text('Send OTP'),
                        ),
                      ),
                    ],
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
