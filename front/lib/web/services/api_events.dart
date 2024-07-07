import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  final String baseUrl;

  EventService({required this.baseUrl});

  Future<List<dynamic>> getAllEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<Map<String, dynamic>> getEvent(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/events/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load event');
    }
  }

  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> event) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(event),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create event');
    }
  }

  Future<Map<String, dynamic>> updateEvent(
      String id, Map<String, dynamic> event) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/events/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(event),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update event');
    }
  }

  Future<void> deleteEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/events/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete event');
    }
  }
}
