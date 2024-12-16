abstract class ChatEvent {}

class LoadChatsEvent extends ChatEvent {}

class LoadArchivedChatsEvent extends ChatEvent {}

class ToggleChatEvent extends ChatEvent {
  final String chatId;
  ToggleChatEvent(this.chatId);
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  DeleteChatEvent(this.chatId);
}
