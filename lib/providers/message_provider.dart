import 'package:flutter/foundation.dart';
import '../models/message.dart';
import '../services/message_service.dart';

class MessageProvider extends ChangeNotifier {
  final MessageService _messageService = MessageService();
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMessages(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _messages = await _messageService.getMessages(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      await _messageService.sendMessage(message);
      _messages.add(message);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _messageService.markMessageAsRead(messageId);
      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        final updatedMessage = Message(
          id: _messages[index].id,
          senderId: _messages[index].senderId,
          receiverId: _messages[index].receiverId,
          content: _messages[index].content,
          timestamp: _messages[index].timestamp,
          isRead: true,
        );
        _messages[index] = updatedMessage;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
