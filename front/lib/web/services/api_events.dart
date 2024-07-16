import 'dart:convert';
import 'package:mobile/web/utils/api_utils.dart';

class EventService {
  Future<List<dynamic>> getAllEvents() async {
    var response = await ApiUtils.get('/events');

    if (response.statusCode == 200) {
      return json.decode(response.data);
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<Map<String, dynamic>> getEvent(String id) async {
    var response = await ApiUtils.get('/events/$id');

    if (response.statusCode == 200) {
      return json.decode(response.data);
    } else {
      throw Exception('Failed to load event');
    }
  }

  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> event) async {
    var response = await ApiUtils.post('/events', event);

    if (response.statusCode == 201) {
      return json.decode(response.data);
    } else {
      throw Exception('Failed to create event');
    }
  }

  Future<Map<String, dynamic>> updateEvent(
      String id, Map<String, dynamic> event) async {
    var response = await ApiUtils.patch('/events/$id', event);
    if (response.statusCode == 200) {
      return json.decode(response.data);
    } else {
      throw Exception('Failed to update event');
    }
  }

  Future<void> deleteEvent(String id) async {
    var response = await ApiUtils.delete('/events/$id', {});

    if (response.statusCode != 204) {
      throw Exception('Failed to delete event');
    }
  }
}
