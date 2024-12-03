// lib/features/chat/domain/usecases/archive_chat.dart
import '../repositories/chat_repository.dart';

class ArchiveChat {
  final ChatRepository repository;

  ArchiveChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.archiveChat(chatId);
  }
}
