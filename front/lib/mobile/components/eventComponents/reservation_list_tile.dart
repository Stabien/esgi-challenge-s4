import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/qr_code_button.dart';
import 'package:mobile/mobile/eventsReservation/blocs/reservation_bloc.dart';
import 'package:mobile/mobile/models/reservation.dart';
import 'package:mobile/mobile/services/format_date.dart';
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
        leading: Image.memory(
          base64Decode(reservation.event.image),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Row(children: [
          Expanded(
            child: Text(
              reservation.event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          QRButton(text: reservation.id)
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
          ],
        ),
      ),
    );
  }
}
