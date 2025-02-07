import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';

abstract class ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Contact> unarchivedChats;
  final List<Contact> archivedChats;
  ChatLoadedState({
    required this.unarchivedChats,
    required this.archivedChats,
  });
}

class ChatErrorState extends ChatState {
  final String error;
  ChatErrorState(this.error);
}
