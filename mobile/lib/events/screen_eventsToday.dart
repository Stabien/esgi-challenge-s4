import 'package:flutter/material.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/services/formatDate.dart';

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

  void _fetchEvents() {
    setState(() {
      _loading = true;
    });
    ApiServices.getEventsToday().then((data) {
      setState(() {
        _error = null;
        _events = data;
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _error = error;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                                          width: 1), // Bordure blanche fine
                                      borderRadius: BorderRadius.circular(
                                          8), // Bordures arrondies
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
