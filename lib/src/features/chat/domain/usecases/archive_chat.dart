import '../repositories/chat_repository.dart';
import '../entities/chat_entity.dart';

/// Use case for toggle a chat.
/// This class interacts with the ChatRepository to toggle a chat unarchived to archived
/// identified by its chatId.
class ToggleChat {
  final ChatRepository repository;

  ToggleChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.toggleChat(chatId);
  }
}

/// Use case for deleting a chat.
/// This class interacts with the ChatRepository to delete a chat
/// identified by its chatId.
class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.deleteChat(chatId);
  }
}

/// Use case for retrieving the list of archived chats.
/// This class interacts with the ChatRepository to fetch all archived chats.
class GetArchivedList {
  final ChatRepository repository;

  GetArchivedList(this.repository);

  Future<List<Contact>> call() async {
    return await repository.getArchivedList();
  }
}

/// Use case for retrieving the list of unactived chats.
/// This class interacts with the ChatRepository to fetch all unactived chats
/// that are not archived.
class GetUnarchivedchatList {
  final ChatRepository repository;

  GetUnarchivedchatList(this.repository);

  Future<List<Contact>> call() async {
    return await repository.getUnarchivedchatList();
  }
}
