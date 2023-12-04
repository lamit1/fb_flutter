import 'package:fb_app/models/notification_model.dart';
import 'package:fb_app/models/user_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class NotificationAPI {
  final DioClient dio = DioClient();

  Future<String?> checkNewItems(
      String lastId,
      String categoryId,
      ) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/check_new_items",
      requestType: RequestType.POST,
      body: {
        "last_id": lastId,
        "category_id": categoryId,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<Notification?> getNotification(
      String index,
      String count,
      ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_notification",
      requestType: RequestType.POST,
      body: {
        "index": index,
        "count": count,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var responseData = response.data['data'];
      Notification temp = Notification.fromJson(responseData);
      return temp;
    } else {
      return null;
    }
  }
}
