import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';

abstract class ChatEvent {}

class LoadChatsEvent extends ChatEvent {}

class LoadArchivedChatsEvent extends ChatEvent {}

class ToggleChatEvent extends ChatEvent {
  final String chatId;
  ToggleChatEvent(this.chatId);
}

class ToggleChatArchived extends ChatEvent {
  final Contact chat;
  ToggleChatArchived(this.chat);
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  DeleteChatEvent(this.chatId);
}

class LoadUnreadMessageCountEvent extends ChatEvent {
  final int contactId;
  LoadUnreadMessageCountEvent(this.contactId);
}
