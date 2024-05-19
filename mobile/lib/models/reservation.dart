class Reservation {
  final String id;

  Reservation({
    required this.id,


  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id : json['id'],

      
      
    );
  }
}
