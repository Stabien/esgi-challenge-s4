import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/mobile/models/event.dart';

class EventListTile extends StatelessWidget {
  final Event event;
  final String eventDate;

  const EventListTile(
      {super.key, required this.event, required this.eventDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(
          '/event/detail',
          arguments: event.id,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        leading: Image.memory(
          base64Decode(event.image),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Row(children: [
          Text(
            event.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ]),
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
      ),
    );
  }
}
