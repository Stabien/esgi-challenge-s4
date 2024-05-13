part of 'eventdetail_bloc.dart';

@immutable
sealed class EventdetailState {}

final class EventdetailInitial extends EventdetailState {}

final class EventdetailLoading extends EventdetailState {}

final class EventdetailDataLoadingSuccess extends EventdetailState {
  final List<Event> events;

  EventdetailDataLoadingSuccess({required this.events});
}

final class EventdetailDataLoadingError extends EventdetailState {
  final String errorMessage;

  EventdetailDataLoadingError({required this.errorMessage});
}