import 'package:fb_app/core/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please enter the 6-digit OTP sent to your email',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 6; i++)
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: TextField(
                              autofocus: true,
                              controller: _controllers[i],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1)
                              ],
                              style: TextStyle(fontSize: 30, height: 38),
                              showCursor: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.isEmpty && i > 0) {
                                  FocusScope.of(context).previousFocus();
                                } else if (value.isNotEmpty) {
                                  if (i < 5) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                }
                              },
                              onSubmitted: (value) {
                                if (value.isEmpty) {
                                  if (i > 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        if (i < 5) SizedBox(width: 10),
                        // Adjust the width as needed
                      ],
                    ),
                ],
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(Size(100, 50))),
                      onPressed: () {
                        String otp = '';
                        for (int i = 0; i < 6; i++) {
                          otp += _controllers[i].text;
                        }

                        if (otp.length == 6) {
                          // Perform OTP verification or other actions
                          // You can navigate to the next screen or show a success message here
                        } else {
                          // Display an error message or handle an invalid OTP
                        }
                      },
                      child: Text('Verify OTP'),
                    ),
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
