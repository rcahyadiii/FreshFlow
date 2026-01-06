import 'package:freshflow_app/features/chat/domain/chat_message.dart';

abstract class ChatRepository {
  List<ChatMessage> getMessages();
  void sendMessage(String author, String text);
}

class InMemoryChatRepository implements ChatRepository {
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      author: 'System',
      text: 'Welcome to Freshflow Chat 👋',
      timestamp: DateTime.now(),
    ),
  ];

  @override
  List<ChatMessage> getMessages() => List.unmodifiable(_messages);

  @override
  void sendMessage(String author, String text) {
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        author: author,
        text: text,
        timestamp: DateTime.now(),
      ),
    );
  }
}
