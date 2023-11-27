import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class ProfileAPI {
  final DioClient dio = DioClient();

  Future<User?> getUserInfo(String userId) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_user_info",
      requestType: RequestType.POST,
      body: {
        "user_id": userId,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var responseData = response.data['data'];
      User user = User(
        name: responseData['username'],
        imageUrl: responseData['avatar'],
        coins: responseData['coins'],
        active: responseData['active'],
      );
      return user;
    } else {
      return null;
    }
  }

  Future<String?> setUserInfo(
    String username,
    String description,
    File avatar,
    String address,
    String city,
    String country,
    File coverImage,
    String link,
  ) async {
    String? token = await Storage().getToken();
    FormData data = FormData.fromMap({
      "username": username,
      "description": description,
      "avatar": avatar,
      "address": address,
      "city": city,
      "country": country,
      "coverImage": coverImage,
      "link": link,
    });
    var response = await DioClient().formDataCall(
      url: "https://it4788.catan.io.vn/set_user_info",
      requestType: RequestType.POST,
      formData: data,
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<String?> changeProfileAfterSignup(
    String username,
    File avatar,
  ) async {
    String? token = await Storage().getToken();
    FormData data = FormData.fromMap({
      "username": username,
      "avatar": avatar,
    });
    var response = await DioClient().formDataCall(
      url: "https://it4788.catan.io.vn/change_profile_after_signup",
      requestType: RequestType.POST,
      formData: data,
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }
}
