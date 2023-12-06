import 'dart:async';

import 'package:fb_app/services/api/auth.dart';

import '../models/user_model.dart';


class AuthenticationRepository {
  Future<User?> login(String email, String password) async {
    await Auth().login(email, password);
  }
  Future<String?> signUp(String email, String password) async {
    return await Auth().signUp(email,password);
  }
  Future<String?> getVerifyCode(String email) async {
    return await Auth().getVerifyCode(email);
  }
}
