import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/models/reservation.dart';
import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/core/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/utils/secureStorage.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  String _userId = "";

  ReservationBloc() : super(ReservationInitial()) {
    on<ReservationEvent>((event, emit) async {
      emit(ReservationLoading());

      try {
        await initUser();
        final reservations = await ApiServices.getMyReservations(_userId);
        print("les reservations sont dans le bloc");
        print(reservations);
        emit(ReservationDataLoadingSuccess(reservations: reservations));
      } on ApiException catch (error) {
        emit(ReservationDataLoadingError(errorMessage: error.message));
      } catch (error) {
        emit(ReservationDataLoadingError(errorMessage: "Unhandled error"));
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
