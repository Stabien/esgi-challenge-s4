import 'package:mobile/mobile/models/reservation.dart';
import 'package:mobile/web/utils/api_utils.dart';

class ApiReservation {
  static Future<void> reserveEvent(String eventId, String customerID) async {
    try {
      Map<String, dynamic> data = {
        'eventID': eventId,
        'customerID': customerID,
      };
      await ApiUtils.post('/reservations', data);
    } catch (error) {
      // print('Erreur inconnue lors de la réservation de l\'événement: $error');
    }
  }

  static Future<List<Reservation>> isreserv(
      String eventId, String customerID) async {
    try {
      var response =
          await ApiUtils.get('/reservations/isreserv/$customerID/$eventId');
      final data = response.data as List;
      return data.map((item) => Reservation.fromJson(item)).toList();
    } catch (error) {
      // print('Unknown error: $error');
      return [];
    }
  }

  static Future<ReservationStatus> isValid(String reservationId) async {
    try {
      var response = await ApiUtils.get('/reservations/isValid/$reservationId');

      final data = ReservationStatus.fromJson(response.data);
      return data;
    } catch (error) {
      // print('Unknown error: $error');
      return ReservationStatus(isValid: false);
    }
  }

  static Future<void> cancelReservation(
      String eventId, String customerID) async {
    try {
      Map<String, dynamic> data = {
        'eventID': eventId,
        'customerID': customerID,
      };

      await ApiUtils.delete('/reservations', data);
    } catch (error) {
      // print(
      //     'Erreur inconnue lors de l\'annulation de la réservation de l\'événement: $error');
    }
  }
}

class ReservationStatus {
  final bool isValid;
  final String? message;
  final String? event;

  ReservationStatus({required this.isValid, this.message, this.event});

  factory ReservationStatus.fromJson(Map<String, dynamic> json) {
    return ReservationStatus(
      isValid: json['isValid'] as bool,
      message: json['message'] as String?,
      event: json['event'] as String?,
    );
  }
}
