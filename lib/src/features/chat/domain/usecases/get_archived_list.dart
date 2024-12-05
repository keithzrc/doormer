import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetArchivedList {
  final ChatRepository repository;

  GetArchivedList(this.repository);

  Future<List<Chat>> call() async {
    return await repository.getArchivedList();
  }
}
