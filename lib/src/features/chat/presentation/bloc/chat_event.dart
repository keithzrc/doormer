import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';

abstract class ChatEvent {}

class LoadChatsEvent extends ChatEvent {}

class LoadArchivedChatsEvent extends ChatEvent {}

class ToggleArchiveStatusEvent extends ChatEvent {
  final Contact contact;
  ToggleArchiveStatusEvent(this.contact);
}


