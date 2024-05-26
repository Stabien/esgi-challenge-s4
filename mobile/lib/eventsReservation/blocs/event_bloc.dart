import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/core/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/utils/secureStorage.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  String _userId = "";

  EventBloc() : super(EventInitial()) {
    on<EventEvent>((event, emit) async {
      emit(EventLoading());

      try {
        await initUser();
        print("a ce moment ");
        print(_userId);
        final events = await ApiServices.getMyReservations(_userId);
        emit(EventDataLoadingSuccess(events: events));
      } on ApiException catch (error) {
        emit(EventDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(EventDataLoadingError(errorMessage: "Unhandled error"));
      }
    });
  }
  Future<void> initUser() async {
    await SecureStorage.getStorageItem('userId').then((value) {
      print("le user id est");
      print(value);
      _userId = value!;
    });
  }
}
