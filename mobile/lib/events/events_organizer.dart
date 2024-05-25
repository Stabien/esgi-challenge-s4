import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/secureStorage.dart';

class EventsOrganizer extends StatefulWidget {
  const EventsOrganizer({super.key});

  @override
  State<EventsOrganizer> createState() => _EventsOrganizerState();
}

class _EventsOrganizerState extends State<EventsOrganizer> {
  late List<Event> _events = [];
  bool _loading = false;
  String userId = "";

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() async {
    String? userId = await SecureStorage.getStorageItem('userId');
    setState(() {
      _loading = true;
    });

    ApiServices.getEventsOrganizer(userId ?? "").then((data) {
      setState(() {
        _loading = false;
        _events = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Evénements organisateur'),
      ),
      body: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : Container(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // button to create an event
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/event/create');
                        },
                        child: const Text('Créer un événement'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/event/join');
                        },
                        child: const Text('Rejoindre un événement'),
                      ),
                    ),
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
                              padding: const EdgeInsets.all(50.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image(image: NetworkImage(event.image)),
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
                                        color: Colors.white,
                                        width: 1,
                                      ), // Bordure blanche fine
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ), // Bordures arrondies
                                    ),
                                    child: Text(
                                      event.tag,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            '/event/update',
                                            arguments: event.id,
                                          );
                                        },
                                        child: const Text('Modifier'),
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
                ))),
    );
  }
}
