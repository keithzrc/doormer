import '../../domain/entities/message_entity.dart';
import '../../domain/entities/contact_info_entity.dart';

abstract class ChatboxState {}

class ChatboxInitial extends ChatboxState {}

class MessagesLoading extends ChatboxState {}

class MessagesLoaded extends ChatboxState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}

class MessageSending extends ChatboxState {}

class MessageSent extends ChatboxState {}

class ContactInfoLoaded extends ChatboxState {
  final ContactInfo contactInfo;
  ContactInfoLoaded(this.contactInfo);
}

class ChatboxError extends ChatboxState {
  final String error;
  ChatboxError(this.error);
}