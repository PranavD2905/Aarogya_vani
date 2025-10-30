import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/message.dart';

class MessageService {
  Future<Directory> get _localDir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  Future<List<Message>> getMessages(String userId) async {
    try {
      final directory = await _localDir;
      final file = File('${directory.path}/messages/$userId/messages.json');

      if (!await file.exists()) {
        return [];
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Message.fromMap(json)).toList();
    } catch (e) {
      print('Error getting messages: $e');
      return [];
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      final directory = await _localDir;
      final senderFile = File(
        '${directory.path}/messages/${message.senderId}/messages.json',
      );
      final receiverFile = File(
        '${directory.path}/messages/${message.receiverId}/messages.json',
      );

      // Create directories if they don't exist
      await senderFile.create(recursive: true);
      await receiverFile.create(recursive: true);

      // Load existing messages
      List<Message> senderMessages = await getMessages(message.senderId);
      List<Message> receiverMessages = await getMessages(message.receiverId);

      // Add new message
      senderMessages.add(message);
      receiverMessages.add(message);

      // Save updated messages
      await senderFile.writeAsString(
        json.encode(senderMessages.map((m) => m.toMap()).toList()),
      );
      await receiverFile.writeAsString(
        json.encode(receiverMessages.map((m) => m.toMap()).toList()),
      );
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  Future<void> markMessageAsRead(String messageId) async {
    // Implementation for marking messages as read
    // This would need to update the message in both sender and receiver files
  }
}
