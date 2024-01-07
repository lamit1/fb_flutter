import 'package:fb_app/models/saved_search_model.dart';
import 'package:fb_app/models/search_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class SearchAPI {
  final DioClient dio = DioClient();

  Future<List<SearchPost>?> search(
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
        "keyword": keyword,
        "index": index,
        "count": count,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var responseData = response.data['data'];
      List<SearchPost> list = [];
      if(responseData != null ){
        for (var item in responseData) {
          SearchPost temp = SearchPost.fromJson(item);
          list.add(temp);
        }
      }
      return list;
    } else {
      return null;
    }
  }

  Future<List<SavedSearch>?> getSavedSearch(
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
      var responseData = response.data['data'];
      List<SavedSearch> list = [];
      for (var item in responseData) {
        SavedSearch temp = SavedSearch.fromJson(item);
        list.add(temp);
      }
      return list;
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
