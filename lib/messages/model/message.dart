class Message {
  final String message;
  final String senderUsername;
  final DateTime sentAt;

  Message({
    required this.message,
    required this.senderUsername,
    required this.sentAt,
  });

  // Factory constructor to create Message objects from JSON data
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      senderUsername: json['senderUsername'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(json['sentAt']),
    );
  }
}
