import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flinq/flinq.dart';
import 'package:mobile/mobile/models/event.dart';
import 'package:mobile/mobile/models/eventDetail.dart';
import 'package:mobile/mobile/core/api_exception.dart';
import 'package:mobile/mobile/models/reservation.dart';
import 'package:mobile/web/utils/api_utils.dart';

class ApiServices {
  static Future<List<Event>> getEvents(search, tag) async {
    var response = await ApiUtils.get('/events?name=$search&tag=$tag');
    try {
      if (response.statusCode != 200) {
        throw ApiException(message: 'Bad request');
      }
      final data = response.data as List<dynamic>;
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
      var response = await ApiUtils.get('/event/$id');
      if (response.statusCode! < 200 || response.statusCode! >= 400) {
        throw ApiException(message: 'Bad request');
      }
      final data = response.data;

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
      var response = await ApiUtils.get('/reservations/$id');

      if (response.statusCode! < 200 || response.statusCode! >= 400) {
        throw ApiException(message: 'Bad request');
      }
      final data = response.data as List<dynamic>;

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
    try {
      var response = await ApiUtils.get('/events/today');
      if (response.statusCode! < 200 || response.statusCode! >= 400) {
        throw ApiException(message: 'Bad request');
      }
      final data = response.data as List<dynamic>;
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
    var response = await ApiUtils.get('/events/organizer');

    List<dynamic> data = response.data;
    List<Event> events = data.map((json) => Event.fromJson(json)).toList();
    return events;
  }

  static Future<void> deleteEvent(String id) async {
    try {
      var response = await ApiUtils.delete('/event/$id', {});

      if (response.statusCode == 200) {
        log('Event deleted successfully');
      }
    } on DioException catch (e) {
      log('Error deleting event: $e');
      throw ApiException(message: 'Error deleting event');
    }
  }

  static Future<bool> eventCreationEnabled() async {
    var response = await ApiUtils.get('/features/event_create');

    try {
      return response.data;
    } catch (error) {
      log('An error occurred while fetching events.', error: error);
      throw ApiException(message: 'Unknown error');
    }
  }
}
