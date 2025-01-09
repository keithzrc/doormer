import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';

abstract class ChatEvent {}

class LoadChatsEvent extends ChatEvent {}

class LoadArchivedChatsEvent extends ChatEvent {}

class ToggleChatEvent extends ChatEvent {
  final Contact contact;
  ToggleChatEvent(this.contact);
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  DeleteChatEvent(this.chatId);
}
