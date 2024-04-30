import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserServices {
  final String baseUrl = dotenv.env['URL_BACK'].toString();
  final Dio dio = Dio();

  Future<Response> auth(String email, String password) async {
    final Response response = await dio.post('$baseUrl/auth', data: {
      email: email,
      password: password,
    });

    return response;
  }
}
