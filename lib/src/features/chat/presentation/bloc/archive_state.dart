// archieve_state.dart
import '../../domain/entities/chat_entity.dart';

abstract class ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Chat> chats;
  ChatLoadedState(this.chats);
}

class ArchivedChatLoadedState extends ChatState {
  final List<Chat> archivedChats;
  ArchivedChatLoadedState(this.archivedChats);
}

class ChatErrorState extends ChatState {
  final String error;
  ChatErrorState(this.error);
  List<Object?> get props => [error];
}
