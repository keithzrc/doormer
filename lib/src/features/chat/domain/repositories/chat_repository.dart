// lib/features/chat/domain/repositories/chat_repository.dart
import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChatList();
  Future<void> archiveChat(String chatId);
  Future<void> deleteChat(String chatId);
  Future<List<Chat>> getArchivedList();
}
