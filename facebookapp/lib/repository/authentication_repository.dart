import 'dart:async';

import 'package:fb_app/services/api_services.dart';

import '../models/user_model.dart';


class AuthenticationRepository {
  Future<User?> login(String email, String password) async {
    return await APIService().login(email, password);
  }
  Future<String?> signUp(String email, String password) async {
    return await APIService().signUp(email,password);
  }
  Future<String?> getVerifyCode(String email) async {
    return await APIService().getVerifyCode(email);
  }
}
