import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';

class BlockAPI {
  final DioClient dio = DioClient();

  Future<String?> setBlock(
    String userId,
  ) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/set_block",
      requestType: RequestType.POST,
      body: {
        "userId": userId,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<Object?> getListBlocks(
    String index,
    String count,
  ) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_list_blocks",
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
}
