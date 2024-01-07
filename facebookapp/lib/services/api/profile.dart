import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fb_app/models/edit_user_profile_model.dart';
import 'package:fb_app/models/user_info_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';
import 'package:http_parser/http_parser.dart';

class ProfileAPI {
  final DioClient dio = DioClient();

  Future<UserInfo> getUserInfo(String userId) async {
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
    var responseData = response.data['data'];
    UserInfo user = UserInfo.fromJson(responseData);
    return user;
  }

  Future<EditProfileResponse> setUserInfo(
    String? username,
    String? description,
    File? avatar,
    String? address,
    String? city,
    String? country,
    File? coverImage,
    String? link,
  ) async {
    String? token = await Storage().getToken();
    FormData data = FormData.fromMap({
      "username": username,
      "description": description,
      "avatar": avatar,
      "address": address,
      "city": city,
      "country": country,
      "cover_image": coverImage,
      "link": link,
    });
    var response = await DioClient().formDataCall(
      url: "https://it4788.catan.io.vn/set_user_info",
      requestType: RequestType.POST,
      formData: data,
      header: {'Authorization': 'Bearer $token'},
    );
    print(response);
    return EditProfileResponse.fromJson(response.data['data']);
  }

  Future<String?> changeProfileAfterSignup(String username, File avatar ) async {
    String? token = await Storage().getToken();

    MultipartFile multipartFile;
    String fileExtension = avatar.path
        .split('.')
        .last
        .toLowerCase(); // Get the file extension
    if (fileExtension == 'png') {
      multipartFile = await MultipartFile.fromFile(
        avatar.path,
        filename: avatar.path
            .split('/')
            .last,
        contentType: MediaType('image', 'png'),
      );
    } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      multipartFile = await MultipartFile.fromFile(
        avatar.path,
        filename: avatar.path
            .split('/')
            .last,
        contentType: MediaType('image', 'jpeg'),
      );
      FormData data = FormData.fromMap({
        "username": username,
        "avatar": multipartFile,
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
}
