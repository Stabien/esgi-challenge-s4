import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/utils/secure_storage.dart';

class ApiUtils {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['URL_BACK'].toString(),
    ),
  );

  static Future<void> _setHeaders() async {
    final String? token = await SecureStorage.getStorageItem('token');
    dio.options.headers['Authorization'] = '$token';
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
  }

  static Future<Response> get(String uri) async {
    await _setHeaders();
    return await dio.get(uri);
  }

  static Future<Response> post(String uri, dynamic data) async {
    await _setHeaders();
    return await dio.post(uri, data: data);
  }

  static Future<Response> patch(String uri, dynamic data) async {
    await _setHeaders();
    return await dio.patch(uri,
        data: data,
        options: Options(headers: {"Content-Type": "application/json"}));
  }

  static Future<Response> patchFormData(String uri, dynamic data) async {
    await _setHeaders();
    return await dio.patch(uri, data: data);
  }

  static Future<Response> delete(String uri, dynamic data) async {
    await _setHeaders();
    return await dio.delete(uri, data: data);
  }
}
