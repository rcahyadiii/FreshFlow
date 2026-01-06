class ChatMessage {
  final String id;
  final String author;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.author,
    required this.text,
    required this.timestamp,
  });
}
