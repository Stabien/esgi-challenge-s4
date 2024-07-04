import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/qr-code-button.dart';
import 'package:mobile/mobile/eventsReservation/blocs/reservation_bloc.dart';
import 'package:mobile/mobile/models/reservation.dart';
import 'package:mobile/mobile/services/formatDate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationListTile extends StatelessWidget {
  final UserReservation reservation;

  const ReservationListTile({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(
          '/event/detail',
          arguments: reservation.event.id,
        )
            .then((_) {
          context.read<ReservationBloc>().add(ReservationDataLoaded());
        }),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        leading: Image.network(
          reservation.event.image,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Row(children: [
          Text(
            reservation.event.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          QRButton(
              text: reservation
                  .event.title) // TODO: Change qr code text for reservation ID
        ]),
        subtitle: Row(
          children: [
            Text(
              transformerDate(reservation.event.date),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                reservation.customerId,
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
