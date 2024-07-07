class Message {
  final String? sender;
  final String date;
  final String text;
  final String userId;

  Message(
      {required this.sender,
      required this.date,
      required this.text,
      required this.userId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      date: json['date'],
      text: json['text'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'date': date,
      'text': text,
      'userId': userId,
    };
  }
}
