import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flinq/flinq.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/event.dart';
import '../core/api_exception.dart';

class ApiServices {
  static Future<List<Event>> getEvents() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/event'));
      await Future.delayed(const Duration(seconds: 1));
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(message: 'Bad request');
      }

      final data = json.decode(response.body) as List<dynamic>;
      return data.mapList((e) => Event.fromJson(e));
    } on SocketException catch (error) {
      log('Network error.', error: error);
      throw ApiException(message: 'Network error');
    } catch (error) {
      log('An error occurred while fetching products.', error: error);
      throw ApiException(message: 'Unknown error');
    }
  }
}
