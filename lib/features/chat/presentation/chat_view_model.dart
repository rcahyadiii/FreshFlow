import 'package:flutter/foundation.dart';
import 'package:freshflow_app/features/chat/data/chat_repository.dart';
import 'package:freshflow_app/features/chat/domain/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repo;

  ChatViewModel(this._repo);

  List<ChatMessage> get messages => _repo.getMessages();

  void send(String author, String text) {
    if (text.trim().isEmpty) return;
    _repo.sendMessage(author, text.trim());
    notifyListeners();
  }

  Future<void> sendWithBotReply(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _repo.sendMessage('You', trimmed);
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    final reply = _botReplyFor(trimmed);
    _repo.sendMessage('Freshflow AI', reply);
    notifyListeners();
  }

  String _botReplyFor(String userText) {
    final t = userText.toLowerCase();
    if (t.contains('flood')) {
      return 'Stay safe. Avoid low-lying areas and monitor alerts.';
    }
    if (t.contains('rain')) {
      return 'Heavy rain expected. Carry an umbrella and check drainage.';
    }
    if (t.contains('water') || t.contains('quality')) {
      return 'Water quality is being monitored. Boil water if uncertain.';
    }
    return 'Got it. How can I help you further?';
  }
}
