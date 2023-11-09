import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';

class APIService {
  final DioClient dio = DioClient();

  Future<User?> login(String email, String password) async {
    var Response = await DioClient().apiCall(
      requestType: RequestType.POST,
      url: 'https://it4788.catan.io.vn/login',
      body: {
        "email": email,
        "password": password,
        "uuid": "String"
      },
    );
    if (Response.statusCode == 200) {
      var response = Response.data['data'];
      User user = User(
          name: response['username'],
          imageUrl: response['avatar'],
          coins: response['coins'],
          active: response['active'],
      ) ;
      Storage().saveToken(response['token']);
      return user;
    } else {
      return null;
    }
  }
}