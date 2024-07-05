import 'package:mobile/mobile/models/event.dart';

class Reservation {
  final String id;

  Reservation({
    required this.id,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
    );
  }
}

class UserReservation {
  final Event event;
  final String id;
  final String customerId;
  final String qrCode;

  UserReservation({
    required this.id,
    required this.qrCode,
    required this.customerId,
    required this.event,
  });

  factory UserReservation.fromJson(Map<String, dynamic> json) {
    return UserReservation(
      id: json['id'],
      qrCode: json['Qrcode'],
      customerId: json['customer_id'],
      event: Event.fromJson(json['Event']),
    );
  }
}
