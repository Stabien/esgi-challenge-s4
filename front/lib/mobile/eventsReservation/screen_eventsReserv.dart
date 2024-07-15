import 'package:flutter/material.dart';
import 'package:mobile/mobile/components/eventComponents/reservationListTile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/mobile/eventsReservation/blocs/reservation_bloc.dart';

class ScreenEventReservation extends StatelessWidget {
  const ScreenEventReservation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReservationBloc()..add(ReservationDataLoaded()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:
              const Text('Mes billets', style: TextStyle(color: Colors.white)),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Column(
              children: [
                Text(
                  'A VENIR',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        body: BlocBuilder<ReservationBloc, ReservationState>(
          builder: (context, state) {
            if (state is ReservationLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ReservationDataLoadingError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (state is ReservationDataLoadingSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final reservations = state.reservations[index];
                  return ReservationListTile(reservation: reservations);
                },
                itemCount: state.reservations.length,
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
