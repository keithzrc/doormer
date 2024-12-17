import '../../domain/entities/message_entity.dart';

abstract class ChatboxEvent {}

class LoadMessages extends ChatboxEvent {
  final String contactId;
  LoadMessages(this.contactId);
}

class SendMessageEvent extends ChatboxEvent {
  final Message message;
  SendMessageEvent(this.message);
}

class SendFileEvent extends ChatboxEvent {
  final String path;
  final MessageType type;
  SendFileEvent(this.path, this.type);
}

class LoadContactInfo extends ChatboxEvent {
  final String contactId;
  LoadContactInfo(this.contactId);
}

class DeleteMessageEvent extends ChatboxEvent {
  final String messageId;
  DeleteMessageEvent(this.messageId);
}

class UpdateMessageEvent extends ChatboxEvent {
  final Message message;
  UpdateMessageEvent(this.message);
}