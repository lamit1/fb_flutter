import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final storage = const FlutterSecureStorage();
  void saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }

  void saveDevToken(String devToken) async {
    await storage.write(key: "devToken", value: devToken);
  }

  Future<String?> getDevToken() async {
    return await storage.read(key: "devToken");
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }
  void deleteToken() async {
    await storage.delete(key: "token");
  }

  getUserId() {}
}