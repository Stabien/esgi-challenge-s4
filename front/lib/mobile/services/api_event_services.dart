import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flinq/flinq.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/mobile/models/event.dart';
import 'package:mobile/mobile/models/eventDetail.dart';
import 'package:mobile/mobile/core/api_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/models/reservation.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';

class ApiServices {
  static final String baseUrl = dotenv.env['URL_BACK'].toString();
  static Future<List<Event>> getEvents(search, tag) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/events?name=$search&tag=$tag'));
      await Future.delayed(const Duration(seconds: 1));
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(message: 'Bad request');
      }
      final data =
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      log(data.toString());
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
      final data =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      // log(data.toString());
      return EventDetail.fromJson(data);
    } on SocketException catch (error) {
      log('Network error.', error: error);
      throw ApiException(message: 'Network error');
    } catch (error) {
      log('An error occurred while fetching events apirequete.', error: error);
      throw ApiException(message: 'Unknown errors');
    }
  }

  static Future<List<UserReservation>> getMyReservations(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/reservations/$id'));
      await Future.delayed(const Duration(seconds: 1));
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(message: 'Bad request');
      }
      final data =
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      // log(data.toString());
      return data.mapList((e) => UserReservation.fromJson(e));
    } on SocketException catch (error) {
      log('Network error.', error: error);
      throw ApiException(message: 'Network error');
    } catch (error) {
      log('An error occurred while fetching events apirequete mes billet.',
          error: error);
      throw ApiException(message: 'Unknown errors');
    }
  }

  static Future<List<Event>> getEventsToday() async {
    print(dotenv.env['URL_BACK'].toString());
    print("-------------------------------");
    try {
      final response = await http.get(Uri.parse('$baseUrl/events/today'));
      await Future.delayed(const Duration(seconds: 1));
      if (response.statusCode < 200 || response.statusCode >= 400) {
        throw ApiException(message: 'Bad request');
      }
      final data =
          json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      print("-------------------------------");
      print(data.toString());
      return data.mapList((e) => Event.fromJson(e));
    } on SocketException catch (error) {
      log('Network error.', error: error);
      throw ApiException(message: 'Network error');
    } catch (error) {
      log('An error occurred while fetching events apirequete.', error: error);
      throw ApiException(message: 'Unknown errors');
    }
  }

  static Future<List<Event>> getEventsOrganizer() async {
    var dio = Dio();

    String? token = await SecureStorage.getStorageItem('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.connectTimeout = const Duration(milliseconds: 10000);

    String? apiUrl = '${dotenv.env['URL_BACK']}/events/organizer';
    var response = await dio.get(apiUrl);
    List<dynamic> data = response.data;
    List<Event> events = data.map((json) => Event.fromJson(json)).toList();
    return events;
  }

  static Future<void> deleteEvent(String id) async {
    var dio = Dio();

    String? token = await SecureStorage.getStorageItem('token');

    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.connectTimeout = const Duration(milliseconds: 10000);

    String? apiUrl = '${dotenv.env['URL_BACK']}/event/$id';
    try {
      var response = await dio.delete(apiUrl);
      if (response.statusCode == 200) {
        log('Event deleted successfully');
      }
    } on DioException catch (e) {
      log('Error deleting event: $e');
      throw ApiException(message: 'Error deleting event');
    }
  }

  static Future<bool> eventCreationEnabled() async {
    var dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['URL_BACK'].toString(),
      ),
    );

    final response = await dio.get('/features/event_create');
    try {
      return response.data;
    } catch (error) {
      log('An error occurred while fetching events.', error: error);
      throw ApiException(message: 'Unknown error');
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
