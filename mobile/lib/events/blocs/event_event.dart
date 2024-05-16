part of 'event_bloc.dart';

@immutable
abstract class EventEvent {
}
class EventDataLoaded extends EventEvent {}


class LoadEventData extends EventEvent {
  final String search; // Définissez le paramètre nécessaire

  LoadEventData(this.search);
}

