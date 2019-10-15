import 'package:dio/dio.dart';

class NetClient {
  ///域名
  static String BASE_URL = "";
  ///超时时间设置 默认20秒
  static int OUT_TIME = 20 * 1000;
  ///是否打印请求日志 默认开启
  static bool DEBUG_LOG = true;

  static Dio get dio => _dio;

  static Dio _dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: OUT_TIME,
      receiveTimeout: OUT_TIME,
      responseType: ResponseType.json))
    ..interceptors.add(LogInterceptor(
      request: DEBUG_LOG,
      requestBody: DEBUG_LOG,
      responseBody: DEBUG_LOG,
      error: DEBUG_LOG,
    ));

  static get(path, Map<String, dynamic> queryParameters) async {
    Response response;
    try {
      response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response;
      } else {
        return Response(statusCode: 400);
      }
    }
  }

  static post(
    path,
    Map<String, dynamic> queryParameters,
  ) async {
    Response response;
    try {
      response = await _dio.post(path, queryParameters: queryParameters);
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        return e.response;
      } else {
        return Response(statusCode: 400);
      }
    }
  }
}
