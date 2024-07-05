part of 'reservation_bloc.dart';

@immutable
sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

final class ReservationLoading extends ReservationState {}

final class ReservationDataLoadingSuccess extends ReservationState {
  final List<UserReservation> reservations;

  ReservationDataLoadingSuccess({required this.reservations});
}

final class ReservationDataLoadingError extends ReservationState {
  final String errorMessage;

  ReservationDataLoadingError({required this.errorMessage});
}
