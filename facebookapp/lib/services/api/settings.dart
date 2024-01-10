import 'package:fb_app/models/push_setting_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class SettingAPI {
  final DioClient dio = DioClient();

  Future<String?> setDevToken() async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    String? devToken = await Storage().getDevToken();
    print("Dev token is $devToken");
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/set_devtoken",
      requestType: RequestType.POST,
      body: {
        "devtype": "1",
        "devtoken": devToken
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if(response.data['code'] != "1000") {
      return null;
    }
    return response.data['code'];
  }

  Future<String?> buyCoins(
    String code,
    String coins,
  ) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/buy_coins",
      requestType: RequestType.POST,
      body: {
        "code": code,
        "coins": coins,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<PushSetting?> getPushSettings() async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_push_settings",
      requestType: RequestType.POST,
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var responseData = response.data['data'];
      PushSetting list = PushSetting.fromJson(responseData);
      return list;
    } else {
      return null;
    }
  }

  Future<String?> setRequestFriend(
    String devtype,
    String devtoken,
  ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/set_devtoken",
      requestType: RequestType.POST,
      body: {
        "devtype": devtype,
        "devtoken": devtoken,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<String?> setPushSettings(
    String likeComment,
    String fromFriends,
    String requestedFriend,
    String suggestedFriend,
    String birthday,
    String video,
    String report,
    String soundOn,
    String notificationOn,
    String vibrantOn,
    String ledOn,
  ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/set_push_settings",
      requestType: RequestType.POST,
      body: {
        "like_comment": likeComment,
        "from_friends": fromFriends,
        "requested_friend": requestedFriend,
        "suggested_friend": suggestedFriend,
        "birthday": birthday,
        "video": video,
        "report": report,
        "sound_on": soundOn,
        "notification_on": notificationOn,
        "vibrant_on": vibrantOn,
        "led_on": ledOn,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }
}
