import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/models/reservation.dart';

class ApiReservation {

  static Future<void> reserveEvent(String eventId, String customerID) async {
    try {
      Dio dio = Dio();
      String url = '${dotenv.env['URL_BACK']}/reservations';

      Map<String, dynamic> data = {
        'eventID': eventId,
        'customerID': customerID,
      };

      Response response = await dio.post(url, data: data);
    } catch (error) {
      print('Erreur inconnue lors de la réservation de l\'événement: $error');
    }
  }

  static Future<List<Reservation>> isreserv(
      String eventId, String customerID) async {
    try {
      Dio dio = Dio();
      String url =
          '${dotenv.env['URL_BACK']}/reservations/isreserv/$customerID/$eventId';

      Response response = await dio.get(url);
      print("Response data: ${response.data}");

      final data = response.data as List;
      return data.map((item) => Reservation.fromJson(item)).toList();
    } catch (error) {
      print('Unknown error: $error');
      return [];
    }
  }

  static Future<ReservationStatus> isValid(String reservationId) async {
    try {
      Dio dio = Dio();
      String url =
          '${dotenv.env['URL_BACK']}/reservations/isValid/$reservationId';

      Response response = await dio.get(url);
      print("Response data: ${response.data}");

      final data = response.data as ReservationStatus;
      return data;
    } catch (error) {
      print('Unknown error: $error');
      return {isValid: false} as ReservationStatus;
    }
  }

  static Future<void> cancelReservation(
      String eventId, String customerID) async {
    try {
      Dio dio = Dio();
      String url = '${dotenv.env['URL_BACK']}/reservations';

      Map<String, dynamic> data = {
        'eventID': eventId,
        'customerID': customerID,
      };

      Response response = await dio.delete(url, data: data);
    } catch (error) {
      print(
          'Erreur inconnue lors de l\'annulation de la réservation de l\'événement: $error');
    }
  }
}

class ReservationStatus {
  final bool isValid;
  final String? message;

  ReservationStatus({required this.isValid, this.message});

  factory ReservationStatus.fromJson(Map<String, dynamic> json) {
    return ReservationStatus(
      isValid: json['isValid'] as bool,
      message: json['message'] as String?,
    );
  }
}
