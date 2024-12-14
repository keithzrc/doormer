import '../repositories/chat_repository.dart';
import '../entities/chat_entity.dart';

/// Use case for archiving a chat.
///
/// This class interacts with the ChatRepository to archive a chat
/// identified by its chatId.
class ArchiveChat {
  final ChatRepository repository;

  ArchiveChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.archiveChat(chatId);
  }
}

/// Use case for deleting a chat.
///
/// This class interacts with the ChatRepository to delete a chat
/// identified by its [chatId].
class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.deleteChat(chatId);
  }
}

/// Use case for retrieving the list of archived chats.
///
/// This class interacts with the ChatRepository to fetch all archived chats.
class GetArchivedList {
  final ChatRepository repository;

  GetArchivedList(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getArchivedList();
  }
}

/// Use case for retrieving the list of active chats.
///
/// This class interacts with the [ChatRepository] to fetch all active chats
/// that are not archived.
class GetChatList {
  final ChatRepository repository;

  GetChatList(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getChatList();
  }
}
