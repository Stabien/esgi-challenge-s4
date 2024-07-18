import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/mobile/models/event.dart';
import 'package:mobile/mobile/services/api_event_services.dart';
import 'package:mobile/mobile/services/format_date.dart';
import 'package:mobile/mobile/utils/translate.dart';

const List<String> list = <String>['', 'Jazz', 'Techno', 'Disco'];

class ScreenEventToday extends StatefulWidget {
  const ScreenEventToday({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(t(context)!.today),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Erreur: $_error'))
                    : _events.isEmpty
                        ? Center(
                            child: Text(t(context)!.noEventToday),
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
