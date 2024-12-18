import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';

/// Abstract class that defines the contract for managing chat data.
/// This repository provides methods to interact with chat-related data,
/// including retrieving chat lists, updating chats, deleting chats, and
/// fetching archived chats. Implementations of this class should handle the
/// actual data access logic, such as interacting with a database, API, or
/// other data sources.
abstract class ChatRepository {
  // TODO: Renaming
  Future<List<Contact>> getActiveChatList();
  Future<List<Contact>> getArchivedChatList();
  Future<void> updateChat(Contact contact);
  Future<void> deleteChat(String chatId);
}
