import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';


import 'package:flinq/flinq.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/event.dart';
import 'package:mobile/core/api_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:convert'; // Importez la bibliothèque pour utiliser json.decode

class ApiServices {
  static final String baseUrl = dotenv.env['URL_BACK'].toString();
  static final Dio dio = Dio();

  static Future<List<Event>> getEvents() async {
    try{
      final Response response = await dio.get('$baseUrl/events');
      final data = json.decode(response.data) as List<Event>;
      return data;
    }catch (error) {
      log('An error occurred while fetching events.', error: error);
      throw ApiException(message: 'Unknown error');
    }
  }
}

// class ApiServices {
//   static final String baseUrl = dotenv.env['URL_BACK'].toString();
//   final Dio dio = Dio();
//   static Future<List<Event>> getEvents() async {
//     try {
//       log("ca passe bien ");
//         final response = await http.get(Uri.parse('$baseUrl/events'));
//       log(response.body.toString());
//       log("c'est passer");
//       await Future.delayed(const Duration(seconds: 1));
//       if (response.statusCode < 200 || response.statusCode >= 400) {
//         throw ApiException(message: 'Bad request');
//       }

//       final data = json.decode(response.body) as List<dynamic>;
//       log(data.toString());
//       return data.mapList((e) => Event.fromJson(e));
//     } on SocketException catch (error) {
//       log('Network error.', error: error);
//       throw ApiException(message: 'Network error');
//     } catch (error) {
//       log('An error occurred while fetching products.', error: error);
//       throw ApiException(message: 'Unknown error');
//     }
//   }
// }
