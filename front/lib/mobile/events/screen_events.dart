import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/eventComponents/eventListTile.dart';
import 'package:mobile/mobile/models/event.dart';
import 'package:mobile/mobile/services/api_event_services.dart';
import 'package:mobile/mobile/services/api_tag_services.dart';
import 'package:mobile/mobile/services/formatDate.dart';
import 'event_search_delegate.dart';

class ScreenEvent extends StatefulWidget {
  const ScreenEvent({super.key});

  @override
  _ScreenEventState createState() => _ScreenEventState();
}

class _ScreenEventState extends State<ScreenEvent> {
  late List<Event> _events = [];
  bool _loading = false;
  dynamic _error;
  String tag = 'Aucun tag sélectionné';
  List<String> list = ['Aucun tag sélectionné'];

  @override
  void initState() {
    super.initState();
    _fetchTags();
    _fetchEvents();
  }

  void _fetchTags() async {
    try {
      final tags = await TagServices.getTags();
      setState(() {
        list = ['Aucun tag sélectionné'];
        for (var tag in tags) {
          list.add(tag.name);
        }
      });
    } catch (error) {
      setState(() {
        _error = error;
      });
    }
  }

  void _fetchEvents() {
    setState(() {
      _loading = true;
    });
    ApiServices.getEvents('', tag == 'Aucun tag sélectionné' ? '' : tag)
        .then((data) {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Événements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: EventSearchDelegate());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.grey[800],
                value: tag,
                icon: const Icon(Icons.arrow_downward, color: Colors.white),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.white),
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
