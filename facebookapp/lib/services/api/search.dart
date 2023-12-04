import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class SearchAPI {
  final DioClient dio = DioClient();

  Future<Object?> search(
    String userId,
    String keyword,
    String index,
    String count,
  ) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/search",
      requestType: RequestType.POST,
      body: {
        "userId": userId,
        "keyword": keyword,
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

  Future<Object?> getSavedSearch(
    String index,
    String count,
  ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_saved_search",
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

  Future<String?> delSavedSearch(
    String searchId,
    String all,
  ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/del_saved_search",
      requestType: RequestType.POST,
      body: {"search_id": searchId, "all": all},
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }
}
