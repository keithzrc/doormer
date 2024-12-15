import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'package:uuid/uuid.dart';

/// Abstract class that defines the contract for managing chat data.
/// This repository provides methods to interact with chat-related data,
/// including retrieving chat lists, archiving chats, deleting chats, and
/// fetching archived chats. Implementations of this class should handle the
/// actual data access logic, such as interacting with a database, API, or
/// other data sources.
abstract class ChatRepository {
  Future<List<Contact>> getUnarchivechatList();
  Future<void> archiveChat(Uuid chatId);
  Future<void> unarchiveChat(String chatId);
  Future<void> deleteChat(Uuid chatId);
  Future<List<Contact>> getArchivedList();
}
