import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_entity.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Chat> chats;

  ChatLoadedState(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ArchivedChatLoadedState extends ChatState {
  final List<Chat> archivedChats;

  ArchivedChatLoadedState(this.archivedChats);

  @override
  List<Object?> get props => [archivedChats];
}

class ChatErrorState extends ChatState {
  final String error;

  ChatErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
