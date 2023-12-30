import 'package:dio/dio.dart';

enum RequestType { GET, POST, PUT, PATCH, DELETE }

class DioClient {
  final dio = createDio();

  DioClient._internal();

  static final _singleton = DioClient._internal();

  factory DioClient() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: "https://it4788.catan.io.vn/",
      receiveTimeout: const Duration(seconds: 20), // 20 seconds
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ));
    return dio;
  }

  Future<Response<dynamic>> apiCall({
    required String url,
    required RequestType requestType,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    Map<String, String>? header,
    RequestOptions? requestOptions,
  }) async {
    try {
      late Response result;

      switch (requestType) {
        case RequestType.GET:
          {
            Options options = Options(headers: header);
            result = await dio.get(url,
                queryParameters: queryParameters, options: options);
            break;
          }
        case RequestType.POST:
          {
            Options options = Options(headers: header);
            result = await dio.post(url, data: body, options: options, queryParameters: queryParameters);
            break;
          }
        case RequestType.DELETE:
          {
            Options options = Options(headers: header);
            result =
            await dio.delete(url, data: queryParameters, options: options);
            break;
          }
        case RequestType.PUT:
          {
            Options options = Options(headers: header);
            result = await dio.put(url, data: body, options: options);
            break;
          }
        case RequestType.PATCH:
          {
            Options options = Options(headers: header);
            result = await dio.patch(url, data: body, options: options);
            break;
          }
      }

      return result;
    } on DioException catch (error) {
      if (error.response != null) {
        print(error.response?.data);
        print(error.response?.headers);
        print(error.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(error.requestOptions);
        print(error.message);
      }
      if (error.response != null && error.response!.statusCode == 400) {
        return error.response!;
      }
      rethrow;
    }
  }

  Future<Response<dynamic>> formDataCall({
    required String url,
    required RequestType requestType,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    Map<String, String>? header,
    RequestOptions? requestOptions,
  }) async {
    try {
      late Response result;
      switch (requestType) {
        case RequestType.GET:
          {
            Options options = Options(headers: header);
            result = await dio.get(url,
                queryParameters: queryParameters, options: options);
            break;
          }
        case RequestType.POST:
          {
            Options options = Options(headers: header);
            result = await dio.post(url, data: formData, options: options, queryParameters: queryParameters);
            break;
          }
        case RequestType.DELETE:
          {
            Options options = Options(headers: header);
            result =
            await dio.delete(url, data: queryParameters, options: options);
            break;
          }
        case RequestType.PUT:
          {
            Options options = Options(headers: header);
            result = await dio.put(url, data: formData, options: options);
            break;
          }
        case RequestType.PATCH:
          {
            Options options = Options(headers: header);
            result = await dio.patch(url, data: formData, options: options);
            break;
          }
      }

      return result;
    } on DioException catch (error) {
      if (error.response != null) {
        print(error.response?.data);
        print(error.response?.headers);
        print(error.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(error.requestOptions);
        print(error.message);
      }
      if (error.response != null && error.response!.statusCode == 400) {
        return error.response!;
      }
      rethrow;
    }
  }

}

