class Event {
  final String id;
  final String title;
  final String description;
  final String tag;
  final String image;
  final String date;
  final String place;
  final bool isPending;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.image,
    required this.date,
    required this.place,
    required this.isPending,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      tag: json['tag'],
      image: json['image'],
      date: json['date'],
      place: json['place'],
      isPending: json['is_pending'],
    );
  }
}
