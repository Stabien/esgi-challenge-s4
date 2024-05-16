import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/services/formatDate.dart';

class ScreenEvent extends StatefulWidget {
  const ScreenEvent({Key? key}) : super(key: key);

  @override
  _ScreenEventState createState() => _ScreenEventState();
}

class _ScreenEventState extends State<ScreenEvent> {
  late List<Event> _events = [];
  bool _loading = false;
  dynamic _error;
  var search = '';

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    setState(() {
      _loading = true;
    });
  print("dans le get search est $search");
    ApiServices.getEvents(search).then((data) {
      print(data);
      setState(() {
        _error = null;
        _events = data; // Mettez à jour la liste d'événements avec les données récupérées
        _loading = false;
      });
      print(data);
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
                      print(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    // Rechargez la page avec de nouvelles données en appelant _fetchEvents()
                    print("le serach est $search");
                    _fetchEvents();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator()) // Affichez un indicateur de chargement si nécessaire
                : _error != null
                    ? Center(child: Text('Erreur: $_error')) // Affichez un message d'erreur si nécessaire
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
