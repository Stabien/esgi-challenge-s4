import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/web/ui/appbar.dart';
import 'package:mobile/web/utils/api_utils.dart';

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
    _fetchEvents();
  }

  void _fetchEvents() {
    _allEventsFuture = fetchAllEvents();
    _pendingEventsFuture = fetchPendingEvents();

    _allEventsFuture.then((events) {
      if (mounted) {
        setState(() {
          _allEvents = events;
        });
      }
    });

    _pendingEventsFuture.then((events) {
      if (mounted) {
        setState(() {
          _pendingEvents = events;
        });
      }
    });
  }

  void _validateEvent(String eventId) async {
    try {
      await validateEvent(eventId);
      setState(() {
        _pendingEvents.removeWhere((event) => event.id == eventId);

        final eventIndex =
            _allEvents.indexWhere((event) => event.id == eventId);
        if (eventIndex != -1) {
          _allEvents[eventIndex] = Event(
            id: _allEvents[eventIndex].id,
            title: _allEvents[eventIndex].title,
            description: _allEvents[eventIndex].description,
            tag: _allEvents[eventIndex].tag,
            banner: _allEvents[eventIndex].banner,
            date: _allEvents[eventIndex].date,
            place: _allEvents[eventIndex].place,
            isPending: false,
          );
        }
      });
    } catch (error) {
      // print(error);
    }
  }

  void _unvalidateEvent(String eventId) async {
    try {
      await unvalidateEvent(eventId);
      setState(() {
        _pendingEvents.removeWhere((event) => event.id == eventId);

        final eventIndex =
            _allEvents.indexWhere((event) => event.id == eventId);
        if (eventIndex != -1) {
          _allEvents[eventIndex] = Event(
            id: _allEvents[eventIndex].id,
            title: _allEvents[eventIndex].title,
            description: _allEvents[eventIndex].description,
            tag: _allEvents[eventIndex].tag,
            banner: _allEvents[eventIndex].banner,
            date: _allEvents[eventIndex].date,
            place: _allEvents[eventIndex].place,
            isPending: true,
          );
        }
      });
    } catch (error) {
      // print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(),
      body: Column(
        children: [
          const Text('Tous les événements', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 50),
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
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          title: Text(event.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.description),
                              Text(
                                event.isPending
                                    ? 'En attente de validation'
                                    : 'Validé',
                                style: TextStyle(
                                  color: event.isPending
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                          leading: Image.memory(
                            base64Decode(event.banner),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 50),
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.description),
                            const Text(
                              'En attente de validation',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
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
  final bool isPending;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.banner,
    required this.date,
    required this.place,
    required this.isPending,
  });
}

Future<List<Event>> fetchAllEvents() async {
  try {
    var response = await ApiUtils.get('/events');

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
              isPending: json['is_pending'],
            ))
        .toList();
  } catch (error) {
    throw Exception('An error occurred while fetching all events');
  }
}

Future<List<Event>> fetchPendingEvents() async {
  try {
    var response = await ApiUtils.get('/events/pending');

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
              isPending: json['is_pending'],
            ))
        .toList();
  } catch (error) {
    throw Exception('An error occurred while fetching pending events');
  }
}

Future<void> validateEvent(String eventId) async {
  try {
    await ApiUtils.patch('/events/$eventId/validate', {});
  } catch (error) {
    throw Exception('An error occurred while validating the event');
  }
}

Future<void> unvalidateEvent(String eventId) async {
  try {
    await ApiUtils.patch('/events/$eventId/unvalidate', {});
  } catch (error) {
    throw Exception('An error occurred while validating the event');
  }
}
