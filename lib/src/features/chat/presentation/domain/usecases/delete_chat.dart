// lib/features/chat/domain/usecases/delete_chat.dart
import '../repositories/chat_repository.dart';

class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.deleteChat(chatId);
  }
}
