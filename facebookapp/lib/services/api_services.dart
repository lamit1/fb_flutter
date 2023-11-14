import 'package:dio/dio.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class APIService {
  final DioClient dio = DioClient();

  Future<User?> login(String email, String password) async {
    String? deviceId = await getDeviceUUID();
    if (deviceId == null) throw Exception("Invalid device!");
    var Response = await DioClient().apiCall(
      requestType: RequestType.POST,
      url: 'https://it4788.catan.io.vn/login',
      body: {"email": email, "password": password, "uuid": deviceId},
    );
    if (Response.statusCode == 200) {
      var response = Response.data['data'];
      User user = User(
        name: response['username'],
        imageUrl: response['avatar'],
        coins: response['coins'],
        active: response['active'],
      );
      Storage().saveToken(response['token']);
      return user;
    } else {
      return null;
    }
  }

  Future<String?> signUp(String email, String password) async {
    String? deviceId = await getDeviceUUID();
      if (deviceId == null) throw Exception("Invalid device!");
      var response = await DioClient().apiCall(
          url: "https://it4788.catan.io.vn/signup",
          requestType: RequestType.POST,
          body: {"email": email, "password": password, "uuid": deviceId});
      return response.data['code'];
  }

  Future<String?> getVerifyCode(String email) async {
    
    var response = await DioClient().apiCall(
        url: "https://it4788.catan.io.vn/get_verify_code",
        requestType: RequestType.POST,
        queryParameters: {"email": email},
    );
    print(response.requestOptions.uri);

    return response.data['code'];
  }

  Future<String?> checkVerifyCode(String email, String otp) async {
    var response = await DioClient().apiCall(
          url: "https://it4788.catan.io.vn/check_verify_code",
          requestType: RequestType.POST,
          body: {"email": email, "code_verify": otp});
    return response.data['code'];
  }
}
