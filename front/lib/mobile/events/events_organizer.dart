import 'dart:convert';

import 'package:mobile/mobile/services/api_event_services.dart';
import 'package:mobile/mobile/models/event.dart';
import 'package:mobile/mobile/services/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/expandable_fab.dart';

class EventsOrganizer extends StatefulWidget {
  const EventsOrganizer({super.key});

  @override
  State<EventsOrganizer> createState() => _EventsOrganizerState();
}

class _EventsOrganizerState extends State<EventsOrganizer> {
  late List<Event> _events = [];
  bool _loading = false;
  bool _eventCreationEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    eventCreationEnabled();
  }

  void _fetchEvents() async {
    setState(() {
      _loading = true;
    });

    ApiServices.getEventsOrganizer().then((data) {
      setState(() {
        _loading = false;
        _events = data;
      });
    });
  }

  void eventCreationEnabled() async {
    try {
      final data = await ApiServices.eventCreationEnabled();
      setState(() {
        _eventCreationEnabled = data;
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evénements organisateur'),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          _eventCreationEnabled
              ? ActionButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).pushNamed(
                      '/event/create',
                    );
                    if (result == true) {
                      _fetchEvents();
                    }
                  },
                  icon: const Icon(Icons.add_box_outlined),
                )
              : const IgnorePointer(
                  ignoring: true,
                  child: Opacity(
                    opacity: 0.5,
                    child: ActionButton(
                      icon: Icon(Icons.add_box_outlined),
                    ),
                  ),
                ),
          ActionButton(
            onPressed: () => Navigator.of(context).pushNamed('/event/join'),
            icon: const Icon(Icons.person_add_alt_rounded),
          ),
          ActionButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Scanner un QR code"),
                content: const Text("Veuillez scanner le QR code."),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Annuler"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text("Scanner"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final event = _events[index];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                              '/event/detail',
                              arguments: event.id,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.memory(base64Decode(event.image)),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        event.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: event.isPending
                                                ? Colors.orange
                                                : Colors.green,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          event.isPending
                                              ? 'En Attente'
                                              : 'Valider',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: event.isPending
                                                ? Colors.orange
                                                : Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      event.tag,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              final result =
                                                  await Navigator.of(context)
                                                      .pushNamed(
                                                '/event/update',
                                                arguments: event.id,
                                              );
                                              if (result == true) {
                                                _fetchEvents();
                                              }
                                            },
                                            child: const Text('Modifier',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                )),
                                          ),
                                          Spacer(),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pushNamed(
                                              '/event/message',
                                              arguments: event.id,
                                            ),
                                            child: const IntrinsicWidth(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.message_outlined),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Supprimer"),
                                            content: const Text(
                                                "Voulez-vous vraiment supprimer cet événement ?"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("Annuler"),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              TextButton(
                                                child: const Text("Supprimer"),
                                                onPressed: () {
                                                  ApiServices.deleteEvent(
                                                          event.id)
                                                      .then((_) {
                                                    Navigator.of(context).pop();
                                                    _fetchEvents();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: const Text('Supprimer'),
                                      ),
                                    ],
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
              ),
      ),
    );
  }
}
