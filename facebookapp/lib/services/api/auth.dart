import 'package:fb_app/models/login_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class Auth {
  final DioClient dio = DioClient();

  Future<LoginResponse?> login(String email, String password) async {
    String? deviceId = await getDeviceUUID();
    if (deviceId == null) throw Exception("Invalid device!");
    var resp = await DioClient().apiCall(
      requestType: RequestType.POST,
      url: 'https://it4788.catan.io.vn/login',
      body: {"email": email, "password": password, "uuid": deviceId},
    );
    if (resp.statusCode == 200) {
      var response = resp.data['data'];
      Storage().saveToken(response['token']);
      return LoginResponse.fromJson(response);
    }
  }

  Future<String?> logOut() async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
        url: "https://it4788.catan.io.vn/logout",
        requestType: RequestType.POST,
        header: {'Authorization': 'Bearer $token'});
    Storage().deleteToken();
    return response.data['code'];
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
      body: {"email": email},
    );

    print(response);

    return response.data['code'];
  }

  Future<String?> checkVerifyCode(String email, String otp) async {
    var response = await DioClient().apiCall(
        url: "https://it4788.catan.io.vn/check_verify_code",
        requestType: RequestType.POST,
        body: {"email": email, "code_verify": otp});
    return response.data['code'];
  }

  Future<String?> resetPassword(
      String email, String password, String otp) async {
    String? deviceId = await getDeviceUUID();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
        url: "https://it4788.catan.io.vn/reset_password",
        requestType: RequestType.POST,
        body: {"email": email, "password": password, "code": otp});
    return response.data['code'];
  }

  Future<String?> changePassword(String password, String newPassword) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
        url: "https://it4788.catan.io.vn/change_pasword",
        requestType: RequestType.POST,
        body: {"password": password, "new_password": newPassword},
        header: {'Authorization': 'Bearer $token'});
    return response.data['code'];
  }

  Future<bool> checkEmailExisted(String email) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
        url: "https://it4788.catan.io.vn/change_pasword",
        requestType: RequestType.POST,
        body: {"email": email,},
        header: {'Authorization': 'Bearer $token'});
    return response.data['data']['existed'] == "0" ? false : true;
  }
}
