// lib/features/chat/domain/usecases/get_chat_list.dart
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatList {
  final ChatRepository repository;

  GetChatList(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getChatList();
  }
}
