import 'package:flutter/material.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/formatDate.dart';



class EventListTile extends StatelessWidget {
  final Event event;
  final String eventDate;

  const EventListTile({Key? key, required this.event, required this.eventDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        fit: BoxFit.cover,
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
            eventDate,
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
  }

}
