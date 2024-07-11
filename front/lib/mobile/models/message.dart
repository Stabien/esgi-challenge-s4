class Message {
  final String sender;
  final String date;
  final String text;
  final String? organizerId;
  final String? eventId;

  Message(
      {required this.sender,
      required this.date,
      required this.text,
      required this.organizerId,
      required this.eventId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      date: json['date'],
      text: json['text'],
      organizerId: json['organizer_id'],
      eventId: json['event_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'date': date,
      'text': text,
      'organizerId': organizerId,
      'eventId': eventId,
    };
  }
}
