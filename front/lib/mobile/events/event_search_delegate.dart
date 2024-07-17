import 'package:flutter/material.dart';
import 'package:mobile/mobile/models/event.dart';
import 'package:mobile/mobile/services/api_event_services.dart';
import 'package:mobile/mobile/services/format_date.dart';
import 'package:mobile/mobile/components/eventComponents/event_list_tile.dart';

class EventSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: ApiServices.getEvents(query, ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Erreur: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('Aucun événement trouvé',
                  style: TextStyle(color: Colors.white)));
        } else {
          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventListTile(
                event: event,
                eventDate: transformerDate(event.date),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
