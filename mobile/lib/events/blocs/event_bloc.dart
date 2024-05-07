import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/core/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventInitial()) {
    on<EventEvent>((event, emit) async {
      emit(EventLoading());

      try {
        final events = await ApiServices.getEvents();
        emit(EventDataLoadingSuccess(events: events));
      } on ApiException catch (error) {
        emit(EventDataLoadingError(errorMessage: error.message));
      }catch (error) {
        emit(EventDataLoadingError(errorMessage: "Unhandled error"));
      }

    });
  }
}
