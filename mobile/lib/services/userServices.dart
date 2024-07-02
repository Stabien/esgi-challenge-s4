import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/core/api_exception.dart';
import 'package:mobile/models/profil.dart';
import 'package:mobile/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flinq/flinq.dart';



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

Future<Profil?> profilCustomer(String id) async {
  try {
    final Response response = await dio.get('$baseUrl/users/custom/$id');
    print("la valeur est : ");
    print(response.data.toString());

    final List<dynamic> dataList = response.data;
    print("Parsing response data...");

    if (dataList.isNotEmpty) {
      final Map<String, dynamic> data = dataList.first;
      print("Parsing item: $data");
      Profil profil = Profil.fromJson(data);
      print("Parsed profil: $profil");
      return profil;
    } else {
      print("No data found");
      return Profil(firstname: "", lastname: "", email: "", password: "");
    }
  } catch (error) {
    print('Unknown error dans profilCustomer: $error');
    return null;
  }
}

Future<Profil?> profilOrga(String id) async {
  try {
    final Response response = await dio.get('$baseUrl/users/orga/$id');
    print("la valeur est : ");
    print(response.data.toString());

    final List<dynamic> dataList = response.data;
    print("Parsing response data...");

    if (dataList.isNotEmpty) {
      final Map<String, dynamic> data = dataList.first;
      print("Parsing item: $data");
      Profil profil = Profil.fromJson(data);
      print("Parsed profil: $profil");
      return profil;
    } else {
      print("No data found");
      return Profil(firstname: "", lastname: "", email: "", password: "");
    }
  } catch (error) {
    print('Unknown error dans profilCustomer: $error');
    return null;
  }
}




//  Future<List> profilCustomer(
//       String id) async {
//     try {
//       Dio dio = Dio();
//       String url =
//           '${dotenv.env['URL_BACK']}/users/custom/$id';

//       Response response = await dio.get(url);
//       print("Response data: ${response.data}");

//       final data = response.data as List;
//       print(data);
//       return data;
//     } catch (error) {
//       print('Unknown error: $error');
//       return [];
//     }
//   }

//  Future<Profil> profilCustomer(String id) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/users/custom/$id'));
//       await Future.delayed(const Duration(seconds: 1));
//       if (response.statusCode < 200 || response.statusCode >= 400) {
//         throw ApiException(message: 'Bad request');
//       }
//       final data =
//           json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
//           print(data);
//       return Profil.fromJson(data);
//     } on SocketException catch (error) {
//       // log('Network error.' as num, error: error);
//       throw ApiException(message: 'Network error');
//     } catch (error) {
//       // log('An error occurred while fetching events apirequete.' as num, error: error);
//       throw ApiException(message: 'Unknown errors');
//     }
//   }

}
