import '../entities/chat_entity.dart';

/// Abstract class that defines the contract for managing chat data.
/// This repository provides methods to interact with chat-related data,
/// including retrieving chat lists, archiving chats, deleting chats, and
/// fetching archived chats. Implementations of this class should handle the
/// actual data access logic, such as interacting with a database, API, or
/// other data sources.
abstract class ChatRepository {
  Future<List<Chat>> getChatList();
  Future<void> archiveChat(String chatId);
  Future<void> unarchiveChat(String chatId);
  Future<void> deleteChat(String chatId);
  Future<List<Chat>> getArchivedList();
}
