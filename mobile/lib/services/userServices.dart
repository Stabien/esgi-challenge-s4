import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/models/user.dart';

class UserServices {
  final String baseUrl = dotenv.env['URL_BACK'].toString();
  final Dio dio = Dio();

  Future<Response> auth(UserCredentials payload) async {
    final Response response = await dio.post('$baseUrl/auth', data: {
      'email': payload.email,
      'password': payload.password,
    });

    return response;
  }

  Future<Response> registerCustomer(UserRegistrationPayload payload) async {
    final Response response = await dio.post('$baseUrl/customers', data: {
      'email': payload.email,
      'password': payload.password,
      'firstname': payload.firstname,
      'lastname': payload.lastname,
    });

    return response;
  }

  Future<Response> registerOrganizer(UserRegistrationPayload payload) async {
    final Response response = await dio.post('$baseUrl/organizers', data: {
      'email': payload.email,
      'password': payload.password,
      'firstname': payload.firstname,
      'lastname': payload.lastname,
    });

    return response;
  }
}
