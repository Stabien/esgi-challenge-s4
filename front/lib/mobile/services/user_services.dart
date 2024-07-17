import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/models/organizer.dart';
import 'package:mobile/mobile/models/profil.dart';
import 'package:mobile/mobile/models/user.dart';
import 'package:mobile/web/utils/api_utils.dart';

class UserServices {
  final String baseUrl = dotenv.env['URL_BACK'].toString();
  final Dio dio = Dio(BaseOptions(
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  ));

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
      var response = await ApiUtils.get('/users/custom/$id');

      final List<dynamic> dataList = response.data;

      if (dataList.isNotEmpty) {
        final Map<String, dynamic> data = dataList.first;
        Profil profil = Profil.fromJson(data);
        return profil;
      } else {
        // print("No data found");
        return Profil(firstname: "", lastname: "", email: "", password: "");
      }
    } catch (error) {
      // print('Unknown error dans profilCustomer: $error');
      return null;
    }
  }

  Future<Profil?> profilOrga(String id) async {
    try {
      var response = await ApiUtils.get('/users/orga/$id');

      final List<dynamic> dataList = response.data;

      if (dataList.isNotEmpty) {
        final Map<String, dynamic> data = dataList.first;
        Profil profil = Profil.fromJson(data);
        return profil;
      } else {
        // print("No data found");
        return Profil(firstname: "", lastname: "", email: "", password: "");
      }
    } catch (error) {
      // print('Unknown error dans profilCustomer: $error');
      return null;
    }
  }

  Future<Organizer?> getOrgaByUser(String id) async {
    try {
      var response = await ApiUtils.get('/organizers/id/$id');

      if (response.data is Map<String, dynamic>) {
        return Organizer.fromJson(response.data);
      } else {
        // print('La réponse n\'est pas un JSON valide');
        return null;
      }
    } catch (error) {
      // print('Unknown error dans profilCustomer: $error');
      return null;
    }
  }

  Future<Profil?> patchProfilOrga(String id, Profil profil) async {
    try {
      var response = await ApiUtils.patch('/users/orga/$id', {
        "lastname": profil.lastname,
        "firstname": profil.firstname,
        "email": profil.email,
      });

      if (response.data != null && response.data.isNotEmpty) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data)
            : response.data as Map<String, dynamic>;

        Profil profil = Profil.fromJson(data);
        return profil;
      } else {
        return Profil(firstname: "", lastname: "", email: "", password: "");
      }
    } catch (e) {
      if (e is DioException) {
        // print('Dio error: ${e.message}');
      } else {
        // print('Unknown error in patchProfilOrga: $e');
      }
      return null;
    }
  }

  Future<Profil?> patchProfilCusto(String id, Profil profil) async {
    try {
      var response = await ApiUtils.patch('/users/custom/$id', {
        "lastname": profil.lastname,
        "firstname": profil.firstname,
        "email": profil.email,
      });

      if (response.data != null && response.data.isNotEmpty) {
        final Map<String, dynamic> data = response.data is String
            ? jsonDecode(response.data)
            : response.data as Map<String, dynamic>;

        Profil profil = Profil.fromJson(data);
        return profil;
      } else {
        return Profil(firstname: "", lastname: "", email: "", password: "");
      }
    } catch (e) {
      if (e is DioException) {
        // print('Dio error: ${e.message}');
      } else {
        // print('Unknown error in patchProfilOrga: $e');
      }
      return null;
    }
  }
}
