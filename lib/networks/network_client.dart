import 'package:dio/dio.dart';
import 'package:flutter_final_project/errors/exceptions.dart';
import 'package:flutter_final_project/utils/constants.dart';

class NetworkClient {
  String? _baseURL;
  Dio _dio = Dio();

  NetworkClient({this._baseURL}) {
    _baseURL ??= Constants.baseURL;

    final baseOptions = BaseOptions(
      receiveTimeout: Duration(seconds: 120),
      connectTimeout: Duration(seconds: 120),
      baseUrl: _baseURL!,
      maxRedirects: 2,
      contentType: "application/json",
    );

    _dio = Dio(baseOptions);

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        error: true,
        requestBody: true,
      ),
    );
  }

  Future<Response> post(
    String url,
    Map<String, dynamic> params, {
    String? token,
  }) async {
    Response respone;

    try {
      Map<String, dynamic> map = {"Accept": "application/json"};

      if (token != null) {
        map.addAll({"Authorization": "Bearer $token"});
      }
      respone = await _dio.post(
        url,
        data: params,
        options: Options(
          headers: map,
          responseType: ResponseType.json,
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (e) {
      throw RemoteException(e);
    }
    return respone;
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    String? token,
  }) async {
    Response respone;

    try {
      Map<String, dynamic> map = {"Accept": "application/json"};

      if (token != null) {
        map.addAll({"Authorization": "Bearer $token"});
      }
      respone = await _dio.get(
        url,
        queryParameters: params,
        options: Options(headers: map),
      );
    } on DioException catch (e) {
      throw RemoteException(e);
    }
    return respone;
  }
}
