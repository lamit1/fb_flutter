import 'package:fb_app/models/user_model.dart';

class Account {
  final String email;
  final String password;
  final String? otp;
  final User? user;
  const Account({required this.email, required this.password, this.otp, this.user});
}