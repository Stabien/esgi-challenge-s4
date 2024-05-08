import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/core/api_exception.dart';

part 'eventdetail_event.dart';
part 'eventdetail_state.dart';

class EventdetailBloc extends Bloc<EventdetailEvent, EventdetailState> {
  EventdetailBloc() : super(EventdetailInitial()) {
    on<EventdetailEvent>((event, emit) async {
      emit(EventdetailLoading());
      try {
        final events = await ApiServices.getEvents();
        emit(EventdetailDataLoadingSuccess(events: events));
      } on ApiException catch (error) {
        emit(EventdetailDataLoadingError(errorMessage: error.message));
      }catch (error) {
        emit(EventdetailDataLoadingError(errorMessage: "Unhandled error"));
      }

    });
  }
}
