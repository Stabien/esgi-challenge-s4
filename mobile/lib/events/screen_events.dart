import 'package:flutter/material.dart';
import 'package:mobile/components/eventComponents/eventListTile.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/services/formatDate.dart';

const List<String> list = <String>['', 'Jazz', 'Techno', 'Disco'];

class ScreenEvent extends StatefulWidget {
  const ScreenEvent({super.key});

  @override
  _ScreenEventState createState() => _ScreenEventState();
}

class _ScreenEventState extends State<ScreenEvent> {
  late List<Event> _events = [];
  bool _loading = false;
  dynamic _error;
  var search = '';
  String tag = '';

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    setState(() {
      _loading = true;
    });
    ApiServices.getEvents(search, tag).then((data) {
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
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Rechercher un event...',
                            filled: true,
                            fillColor: const Color.fromARGB(255, 100, 98, 98),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 1.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          onChanged: (value) {
                            search = value;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        color: Colors.white,
                        onPressed: () {
                          _fetchEvents();
                        },
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: tag,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        tag = newValue!;
                        _fetchEvents();
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
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
                          return EventListTile(
                              event: event,
                              eventDate: transformerDate(event.date));
                        },
                        itemCount: _events.length,
                      ),
          ),
        ],
      ),
    );
  }
}
