// lib/features/chat/domain/usecases/archive_chat.dart
import '../repositories/chat_repository.dart';
import '../entities/chat_entity.dart';
class ArchiveChat {
  final ChatRepository repository;

  ArchiveChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.archiveChat(chatId);
  }
}
// lib/features/chat/domain/usecases/delete_chat.dart


class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.deleteChat(chatId);
  }
}


class GetArchivedList {
  final ChatRepository repository;

  GetArchivedList(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getArchivedList();
  }
}
// lib/features/chat/domain/usecases/get_chat_list.dart


class GetChatList {
  final ChatRepository repository;

  GetChatList(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getChatList();
  }
}
