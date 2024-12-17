import '../entities/message_entity.dart';
import '../entities/contact_info_entity.dart';

abstract class ChatboxRepository {
  Stream<List<Message>> getMessages(String contactId);
  Future<void> sendMessage(Message message);
  Future<void> sendFile(String path, MessageType type);
  Future<ContactInfo> getContactInfo(String contactId);
  Future<void> deleteMessage(String messageId);
  Future<void> updateMessage(Message message);
}
