import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/mobile/utils/secureStorage.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  EventsPageState createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  late Future<List<Event>> _allEventsFuture;
  late Future<List<Event>> _pendingEventsFuture;
  List<Event> _allEvents = [];
  List<Event> _pendingEvents = [];

  @override
  void initState() {
    super.initState();
    _allEventsFuture = fetchAllEvents();
    _pendingEventsFuture = fetchPendingEvents();

    _allEventsFuture.then((events) {
      setState(() {
        _allEvents = events;
      });
    });

    _pendingEventsFuture.then((events) {
      setState(() {
        _pendingEvents = events;
      });
    });
  }

  void _validateEvent(String eventId) async {
    try {
      await validateEvent(eventId);
      setState(() {
        _pendingEvents.removeWhere((event) => event.id == eventId);
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: Column(
        children: [
          const Text('Tous les événements', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _allEventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: _allEvents.length,
                    itemBuilder: (context, index) {
                      final event = _allEvents[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.description),
                        leading: Image.memory(
                          base64Decode(event.banner),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const Text('Événements en attente de validation',
              style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Event>>(
              future: _pendingEventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (_pendingEvents.isEmpty) {
                  return const Center(
                      child: Text('Aucun événement en attente'));
                } else {
                  return ListView.builder(
                    itemCount: _pendingEvents.length,
                    itemBuilder: (context, index) {
                      final event = _pendingEvents[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.description),
                        leading: Image.memory(
                          base64Decode(event.banner),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _validateEvent(event.id),
                          child: const Text('Valider'),
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.grey[400]!,
                            width: 1,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final String tag;
  final String banner;
  final String date;
  final String place;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.banner,
    required this.date,
    required this.place,
  });
}

Future<List<Event>> fetchAllEvents() async {
  try {
    final dio = Dio();

    final token = await SecureStorage.getStorageItem('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.connectTimeout = const Duration(milliseconds: 10000);

    final apiUrl = '${dotenv.env['URL_BACK']}/events';
    final response = await dio.get(apiUrl);
    final List<dynamic> jsonList = response.data;
    return jsonList
        .map((json) => Event(
              id: json['id'],
              title: json['title'],
              description: json['description'],
              tag: json['tag'],
              banner: json['banner'],
              date: json['date'],
              place: json['place'],
            ))
        .toList();
  } catch (error) {
    throw Exception('An error occurred while fetching all events');
  }
}

Future<List<Event>> fetchPendingEvents() async {
  try {
    final dio = Dio();

    final token = await SecureStorage.getStorageItem('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.connectTimeout = const Duration(milliseconds: 10000);

    final apiUrl = '${dotenv.env['URL_BACK']}/events/pending';
    final response = await dio.get(apiUrl);
    final List<dynamic> jsonList = response.data;
    return jsonList
        .map((json) => Event(
              id: json['id'],
              title: json['title'],
              description: json['description'],
              tag: json['tag'],
              banner: json['banner'],
              date: json['date'],
              place: json['place'],
            ))
        .toList();
  } catch (error) {
    throw Exception('An error occurred while fetching pending events');
  }
}

Future<void> validateEvent(String eventId) async {
  try {
    final dio = Dio();

    final token = await SecureStorage.getStorageItem('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.connectTimeout = const Duration(milliseconds: 10000);

    final apiUrl = '${dotenv.env['URL_BACK']}/events/$eventId/validate';
    await dio.patch(apiUrl);
  } catch (error) {
    throw Exception('An error occurred while validating the event');
  }
}
