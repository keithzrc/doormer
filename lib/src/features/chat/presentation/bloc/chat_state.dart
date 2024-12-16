// archieve_state.dart
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';

abstract class ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Contact> chats;
  ChatLoadedState(this.chats);
}

class ArchivedChatLoadingState extends ChatState {}

class ArchivedChatLoadedState extends ChatState {
  final List<Contact> archivedChats;
  ArchivedChatLoadedState(this.archivedChats);
}

class ChatErrorState extends ChatState {
  final String error;
  ChatErrorState(this.error);
}
