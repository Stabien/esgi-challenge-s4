import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/mobile/models/event.dart';
import 'package:mobile/mobile/services/api_event_services.dart';
import 'package:mobile/mobile/services/formatDate.dart';

const List<String> list = <String>['', 'Jazz', 'Techno', 'Disco'];

class ScreenEventToday extends StatefulWidget {
  const ScreenEventToday({super.key});

  @override
  _ScreenEventState createState() => _ScreenEventState();
}

class _ScreenEventState extends State<ScreenEventToday> {
  late List<Event> _events = [];
  bool _loading = false;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchEvents() {
    setState(() {
      _loading = true;
    });
    ApiServices.getEventsToday().then((data) {
      if (mounted) {
        setState(() {
          _error = null;
          _events = data;
          _loading = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _error = error;
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.all(1.0),
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Text("Aujourd'hui",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Erreur: $_error'))
                    : _events.isEmpty
                        ? const Center(
                            child: Text('Aucun événement trouvé aujourd\'hui'),
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              final event = _events[index];
                              return GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                  '/event/detail',
                                  arguments: event.id,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.memory(base64Decode(event.image)),
                                      Text(
                                        event.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        event.place,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        transformerDate(event.date),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          event.tag,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: _events.length,
                          ),
          ),
        ],
      ),
    );
  }
}
