import 'dart:math';

import 'package:flutter/material.dart';
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
    ApiServices.getEvents(search,tag).then((data) {
      setState(() {
        _error = null;
        _events = data; // Mettez à jour la liste d'événements avec les données récupérées
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Rechercher...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
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
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Erreur: $_error'))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          final event = _events[index];
                          return ListTile(
                            onTap: () => Navigator.of(context).pushNamed(
                              '/event/detail',
                              arguments: event.id,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                            leading: Image.network(
                              event.image,
                              width: 100,
                              height: 100,
                            ),
                            title: Text(
                              event.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  transformerDate(event.date),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    event.place,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
