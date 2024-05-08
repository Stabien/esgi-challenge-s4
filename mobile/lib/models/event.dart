class Event {
  final String id;
  final String title;
  final String description;
  final String tag;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id : json['id'],
      title: json['title'],
      description: json['description'],
      tag: json['tag'],
    );
  }
}
