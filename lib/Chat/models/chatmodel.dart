

class ChatMessage {
  final String sender;
  final String text;
  final String timestamp;

  ChatMessage({required this.sender, required this.text, required this.timestamp});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender'],
      text: json['text'],
      timestamp: json['timestamp'],
    );
  }
}

