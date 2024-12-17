// lib/src/features/chatbox/domain/usecases/chatbox_usecases.dart
import '../repositories/chatbox_repository.dart';
import '../entities/message_entity.dart';
import '../entities/contact_info_entity.dart';

class GetMessages {
  final ChatboxRepository repository;
  GetMessages(this.repository);

  Stream<List<Message>> call(String contactId) {
    return repository.getMessages(contactId);
  }
}

class SendMessage {
  final ChatboxRepository repository;
  SendMessage(this.repository);

  Future<void> call(Message message) {
    return repository.sendMessage(message);
  }
}

class SendFile {
  final ChatboxRepository repository;
  SendFile(this.repository);

  Future<void> call(String path, MessageType type) {
    return repository.sendFile(path, type);
  }
}

class GetContactInfo {
  final ChatboxRepository repository;
  GetContactInfo(this.repository);

  Future<ContactInfo> call(String contactId) {
    return repository.getContactInfo(contactId);
  }
}
