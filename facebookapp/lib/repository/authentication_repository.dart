import 'dart:async';

import 'package:fb_app/services/api_services.dart';

import '../models/user_model.dart';


class AuthenticationRepository {
  Future<User?> login(String email, String password) async {
    return await APIService().login(email, password);
  }
}
