import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class FriendAPI {
  final DioClient dio = DioClient();

  Future<Object?> getRequestedFriends(
    String index,
    String count,
  ) async {
    String? token = Storage().getToken() as String?;
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_requested_friends",
      requestType: RequestType.POST,
      body: {
        "index": index,
        "count": count,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      return null;
    }
  }

  Future<Object?> getUserFriends(
    String index,
    String count,
    String userId,
  ) async {
    String? token = Storage().getToken() as String?;
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_user_friends",
      requestType: RequestType.POST,
      body: {
        "index": index,
        "count": count,
        "user_id": userId,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      return null;
    }
  }

  Future<Object?> getSuggestedFriends(
    String index,
    String count,
  ) async {
    String? token = Storage().getToken() as String?;
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_suggested_friends",
      requestType: RequestType.POST,
      body: {
        "index": index,
        "count": count,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      return null;
    }
  }

  Future<String?> setRequestFriend(
    String userId,
  ) async {
    String? token = Storage().getToken() as String?;
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/set_request_friend",
      requestType: RequestType.POST,
      body: {
        "user_id": userId,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<String?> setAcceptFriend(
    String userId,
    String isAccept,
  ) async {
    String? token = Storage().getToken() as String?;
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/set_accept_friend",
      requestType: RequestType.POST,
      body: {
        "user_id": userId,
        "is_accept": isAccept,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }
}
