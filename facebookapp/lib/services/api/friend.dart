import 'package:fb_app/models/friend_model.dart';
import 'package:fb_app/models/suggested_friends_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';

class FriendAPI {
  final DioClient dio = DioClient();

  Future<List<Friend>?> getRequestedFriends(
    String index,
    String count,
  ) async {
    String? token = await Storage().getToken();
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
      var responseData = response.data['data'];
      List<Friend> list = [];
      for (var item in responseData['request']) {
        Friend temp = Friend.fromJson(item);
        list.add(temp);
      }
      return list;
    } else {
      return null;
    }
  }

  Future<List<Friend>?> getUserFriends(
    String index,
    String count,
    String userId,
  ) async {
    String? token = await Storage().getToken();
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
      var responseData = response.data['data'];
      List<Friend> list = [];
      for (var item in responseData['friends']) {
        Friend temp = Friend.fromJson(item);
        list.add(temp);
      }
      return list;
    } else {
      return null;
    }
  }

  Future<List<SuggestedFriend>?> getSuggestedFriends(
    String index,
    String count,
  ) async {
    String? token = await Storage().getToken();
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
      var responseData = response.data['data'];
      List<SuggestedFriend> list = [];
      for (var item in responseData['list_users']) {
        SuggestedFriend temp = SuggestedFriend.fromJson(item);
        list.add(temp);
      }
      return list;
    } else {
      return null;
    }
  }

  Future<String?> setRequestFriend(
    String userId,
  ) async {
    String? token = await Storage().getToken();
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
    String? token = await Storage().getToken();
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

  Future<String?> unfriend(
      String userId,
      ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/unfriend",
      requestType: RequestType.POST,
      body: {
        "user_id": userId,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<String?> delRequestFriend(
      String userId,
      ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/del_request_friend",
      requestType: RequestType.POST,
      body: {
        "user_id": userId,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }
}
