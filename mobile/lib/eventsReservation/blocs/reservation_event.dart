part of 'reservation_bloc.dart';

@immutable
sealed class ReservationEvent {}

final class ReservationDataLoaded extends ReservationEvent {}
