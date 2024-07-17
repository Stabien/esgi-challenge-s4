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
  List<Event> _allEvents = [];
  List<Event> _pendingEvents = [];
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initializeFutures();
  }

  Future<void> _initializeFutures() async {
    try {
      _allEvents = await fetchAllEvents();
      if (_isMounted) {
        setState(() {});
      }

      _pendingEvents = await fetchPendingEvents();
      if (_isMounted) {
        setState(() {});
      }
    } catch (error) {
      if (_isMounted) {
        setState(() {});
      }
      // print('Error initializing futures: $error');
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _validateEvent(String eventId) async {
    try {
      await validateEvent(eventId);
      if (_isMounted) {
        setState(() {
          _pendingEvents.removeWhere((event) => event.id == eventId);
        });
      }
    } catch (error) {
      // print('Error validating event: $error');
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
            child: _buildEventList(_allEvents),
          ),
          const Text('Événements en attente de validation',
              style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Expanded(
            child: _buildPendingEventList(_pendingEvents),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(List<Event> events) {
    if (events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.description),
              Text(
                event.isPending ? 'En attente de validation' : 'Validé',
                style: TextStyle(
                  color: event.isPending ? Colors.orange : Colors.green,
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

  Widget _buildPendingEventList(List<Event> events) {
    if (events.isEmpty) {
      return const Center(child: Text('Aucun événement en attente'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
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
