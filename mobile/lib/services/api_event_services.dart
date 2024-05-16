import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';


import 'package:flinq/flinq.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/event.dart';
import 'package:mobile/models/eventDetail.dart';
import 'package:mobile/core/api_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiServices {
  static final String baseUrl = dotenv.env['URL_BACK'].toString();
    static Future<List<Event>> getEvents(search) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/events?name=$search'));
      await Future.delayed(const Duration(seconds: 1));
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(message: 'Bad request');
      }
      final data = json.decode(response.body) as List<dynamic>;
      // log(data.toString());
      return data.mapList((e) => Event.fromJson(e));
    } on SocketException catch (error) {
      log('Network error.', error: error);
      throw ApiException(message: 'Network error');
    } catch (error) {
      log('An error occurred while fetching events apirequete.', error: error);
      throw ApiException(message: 'Unknown errors');
    }
  }

static Future<EventDetail> getEventDetail(String id) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/event/$id'));
    await Future.delayed(const Duration(seconds: 1));
    if (response.statusCode < 200 || response.statusCode >= 400) {
      throw ApiException(message: 'Bad request');
    }
    final data = json.decode(response.body) as Map<String, dynamic>; // Correction ici
    log(data.toString());
    return EventDetail.fromJson(data); // Correction ici
  } on SocketException catch (error) {
    log('Network error.', error: error);
    throw ApiException(message: 'Network error');
  } catch (error) {
    log('An error occurred while fetching events apirequete.', error: error);
    throw ApiException(message: 'Unknown errors');
  }
}

    static Future<List<Event>> getMyEvent(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reservations/$id'));
      await Future.delayed(const Duration(seconds: 1));
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(message: 'Bad request');
      }
      final data = json.decode(response.body) as List<dynamic>;
      // log(data.toString());
      return data.mapList((e) => Event.fromJson(e));
    } on SocketException catch (error) {
      log('Network error.', error: error);
      throw ApiException(message: 'Network error');
    } catch (error) {
      log('An error occurred while fetching events apirequete.', error: error);
      throw ApiException(message: 'Unknown errors');
    }
  }

}

//   static final String baseUrl = dotenv.env['URL_BACK'].toString();
//   static final Dio dio = Dio();

//   static Future<List<Event>> getEvents() async {
//     try {
//       final Response response = await dio.get('$baseUrl/events');
//       final List<dynamic> eventData = response.data as List<dynamic>;
//       final List<Event> events = eventData.map((eventJson) {
//         return Event.fromJson(eventJson as Map<String, dynamic>);
//       }).toList();
//       return events;
//     } catch (error) {
//       log('An error occurred while fetching events.', error: error);
//       throw ApiException(message: 'Unknown error');
//     }
//   }
// }