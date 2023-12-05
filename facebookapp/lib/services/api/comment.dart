import 'package:fb_app/models/feel_list_model.dart';
import 'package:fb_app/models/mark_cmt_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class CommentAPI {
  final DioClient dio = DioClient();

  Future<String?> feel(
    String id,
    String type,
  ) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/feel",
      requestType: RequestType.POST,
      body: {
        "id": id,
        "type": type,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<List<MarkComments>?> getMarkComment(
    String id,
    String index,
    String count,
  ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_mark_comment",
      requestType: RequestType.POST,
      body: {
        "id": id,
        "index": index,
        "count": count,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var responseData = response.data['data'];
      List<MarkComments> list = [];
      for (var item in responseData) {
        MarkComments temp = MarkComments.fromJson(item);
        list.add(temp);
      }
      return list;
    } else {
      return null;
    }
  }

  Future<List<FeelList>?> getListFeels(
    String id,
    String index,
    String count,
  ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_list_feels",
      requestType: RequestType.POST,
      body: {
        "id": id,
        "index": index,
        "count": count,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var responseData = response.data['data'];
      List<FeelList> list = [];
      for (var item in responseData['request']) {
        FeelList temp = FeelList.fromJson(item);
        list.add(temp);
      }
      return list;
    } else {
      return null;
    }
  }

  Future<String?> setMarkComment(
    String id,
    String content,
    String index,
    String count,
    String markId,
    String type,
  ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/settings/set_mark_comment",
      requestType: RequestType.POST,
      body: {
        "id": id,
        "content": content,
        "index": index,
        "count": count,
        "mark_id": markId,
        "type": type,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<String?> deleteFeel(
      String id,
      ) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/delete_feel",
      requestType: RequestType.POST,
      body: {
        "id": id,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }
}