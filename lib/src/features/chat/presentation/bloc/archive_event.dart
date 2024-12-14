abstract class ChatEvent {}

class LoadChatsEvent extends ChatEvent {}

class LoadArchivedChatsEvent extends ChatEvent {}

class ArchiveChatEvent extends ChatEvent {
  final String chatId;
  ArchiveChatEvent(this.chatId);
}

class UnArchiveChatEvent extends ChatEvent {
  final String chatId;
  UnArchiveChatEvent(this.chatId);
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  DeleteChatEvent(this.chatId);
}
