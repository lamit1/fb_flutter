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
    String? token = Storage().getToken() as String?;
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

  Future<Object?> getMarkComment(
    String id,
    String index,
    String count,
  ) async {
    String? token = Storage().getToken() as String?;
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
      return response.data['data'];
    } else {
      return null;
    }
  }

  Future<Object?> getListFeels(
    String id,
    String index,
    String count,
  ) async {
    String? token = Storage().getToken() as String?;
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get-list-feels",
      requestType: RequestType.POST,
      body: {
        "id": id,
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

  Future<String?> setMarkComment(
    String id,
    String content,
    String index,
    String count,
    String markId,
    String type,
  ) async {
    String? token = Storage().getToken() as String?;
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
}
