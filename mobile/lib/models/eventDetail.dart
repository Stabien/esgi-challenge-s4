class EventDetail {
  final String id;
  final String title;
  final String description;
  final String tag;
  final String image;
  final String banner;
  final String date;
  final String place;
  final String location;
  final int participantNumber;
  final double lat;
  final double lng;

  EventDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.image,
    required this.date,
    required this.place,
    required this.location,
    required this.participantNumber,
    required this.lat,
    required this.lng,
    required this.banner,

  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      id : json['id'],
      title: json['title'],
      description: json['description'],
      tag: json['tag'],
      image: json['image'],
      date: json['date'],
      place: json['place'],
      location: json['location'],
      participantNumber: json['participant_number'],
      lat: json['lat'],
      lng: json['lng'],
      banner: json['banner'],
      
      
    );
  }
}
