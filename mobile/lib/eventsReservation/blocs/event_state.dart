part of 'event_bloc.dart';

@immutable
sealed class EventState {}

final class EventInitial extends EventState {}

final class EventLoading extends EventState {}

final class EventDataLoadingSuccess extends EventState {
  final List<Event> events;

  EventDataLoadingSuccess({required this.events});
}

final class EventDataLoadingError extends EventState {
  final String errorMessage;

  EventDataLoadingError({required this.errorMessage});
}