import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fb_app/models/post_detail_model.dart';
import 'package:fb_app/models/post_model.dart';
import 'package:fb_app/models/video_model.dart';
import 'package:fb_app/services/dio_client.dart';
import 'package:fb_app/services/storage.dart';
import 'package:fb_app/utils/get_device_uuid.dart';
import 'package:logger/logger.dart';

class PostAPI {
  final DioClient dio = DioClient();

  Future<PostDetail?> getPost(String id) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_post",
      requestType: RequestType.POST,
      body: {"id": id},
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var responseData = response.data['data'];
      PostDetail port = PostDetail.fromJson(responseData);
      return port;
    } else {
      return null;
    }
  }

  Future<String?> addPost(List<File> images,
      File video,
      String described,
      String status,
      String autoAccept,) async {
    String? token = await Storage().getToken();
    FormData data = FormData.fromMap({
      "username": images,
      "avatar": video,
      "described": described,
      "status": status,
      "auto_accept": autoAccept,
    });
    var response = await DioClient().formDataCall(
      url: "https://it4788.catan.io.vn/add_post",
      requestType: RequestType.POST,
      formData: data,
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<String?> editPost(List<File> images,
      File video,
      String described,
      String status,
      String autoAccept,
      String id,
      String imageDel,
      String imageSort,) async {
    String? token = await Storage().getToken();
    FormData data = FormData.fromMap({
      "image": images,
      "video": video,
      "described": described,
      "status": status,
      "auto_accept": autoAccept,
      "id": id,
      "image_del": imageDel,
      "image_sort": imageSort,
    });
    var response = await DioClient().formDataCall(
      url: "https://it4788.catan.io.vn/edit_post",
      requestType: RequestType.POST,
      formData: data,
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<String?> reportPost(String id,
      String subject,
      String details,) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/report_post",
      requestType: RequestType.POST,
      body: {
        "id": id,
        "subject": subject,
        "details": details,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<String?> deletePost(String id,) async {
    String? token = await Storage().getToken();
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/delete_post",
      requestType: RequestType.POST,
      body: {
        "id": id,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    return response.data['code'];
  }

  Future<List<Post>?> getListPosts(String userId,
      String inCampaign,
      String campaignId,
      String latitude,
      String longitude,
      String lastId,
      String index,
      String count,) async {
    try {
      String? deviceId = await getDeviceUUID();
      String? token = await Storage().getToken();
      if (deviceId == null) throw Exception("Invalid device!");

      var response = await DioClient().apiCall(
        url: "https://it4788.catan.io.vn/get_list_posts",
        requestType: RequestType.POST,
        body: {
          "user_id": userId,
          "in_campaign": inCampaign,
          "campaign_id": campaignId,
          "latitude": latitude,
          "longitude": longitude,
          "last_id": lastId,
          "index": index,
          "count": count,
        },
        header: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
          var responseData = response.data['data'];
          Logger().d("NULL POSTS: ${(responseData['post'][0])}" );
          List<Post>? postList = (responseData['post'] as List)
              .map((x) => Post.fromJson(x))
              .toList();
          return postList;
        }
        return null;
    } catch (error) {
      Logger().e("Error getting list of posts: $error");
      return null;
    }
  }

  Future<List<PostDetail>?> getListVideos(String userId,
      String inCampaign,
      String campaignId,
      String latitude,
      String longitude,
      String lastId,
      String index,
      String count,) async {
    String? deviceId = await getDeviceUUID();
    String? token = await Storage().getToken();
    if (deviceId == null) throw Exception("Invalid device!");
    var response = await DioClient().apiCall(
      url: "https://it4788.catan.io.vn/get_list_videos",
      requestType: RequestType.POST,
      body: {
        "user_id": userId,
        "in_campaign": inCampaign,
        "campaign_id": campaignId,
        "latitude": latitude,
        "longitude": longitude,
        "last_id": lastId,
        "index": index,
        "count": count,
      },
      header: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var responseData = response.data['data'];
      List<PostDetail> portList = [];
      for (var item in responseData) {
        PostDetail port = PostDetail.fromJson(item);
        portList.add(port);
      }
      return portList;
    } else {
      return null;
    }
  }
}