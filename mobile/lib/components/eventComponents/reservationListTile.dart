import 'package:flutter/material.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/components/qr-code-button.dart';

class ReservationListTile extends StatelessWidget {
  final Event event;
  final String eventDate;

  const ReservationListTile(
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
        leading: Image.network(
          event.image,
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
          const SizedBox(width: 10),
          QRButton(
              text: event.title) // TODO: Change qr code text for reservation ID
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
