class Organizer {
  String id;

  Organizer({
    required this.id,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'],
    );
  }
}
