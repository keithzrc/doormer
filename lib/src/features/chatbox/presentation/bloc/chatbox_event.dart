import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

/// Base class for all chatbox events
abstract class ChatboxEvent extends Equatable {
  /// Creates a new instance of [ChatboxEvent]
  const ChatboxEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load messages for a specific contact
class LoadMessages extends ChatboxEvent {
  /// The ID of the contact whose messages should be loaded
  final String contactId;

  /// Creates a new [LoadMessages] event
  const LoadMessages(this.contactId);

  @override
  List<Object?> get props => [contactId];
}

/// Event to send a new message
class SendMessageEvent extends ChatboxEvent {
  /// The message to be sent
  final Message message;

  /// Creates a new [SendMessageEvent] event
  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event to send a file
class SendFileEvent extends ChatboxEvent {
  /// The path to the file to be sent
  final String path;

  /// The type of message this file represents
  final MessageType type;

  /// Creates a new [SendFileEvent] event
  const SendFileEvent(this.path, this.type);

  @override
  List<Object?> get props => [path, type];
}

/// Event to load contact information
class LoadContactInfo extends ChatboxEvent {
  /// The ID of the contact whose information should be loaded
  final String contactId;

  /// Creates a new [LoadContactInfo] event
  const LoadContactInfo(this.contactId);

  @override
  List<Object?> get props => [contactId];
}

/// Event to delete a message
class DeleteMessageEvent extends ChatboxEvent {
  /// The ID of the message to be deleted
  final String messageId;

  /// Creates a new [DeleteMessageEvent] event
  const DeleteMessageEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

/// Event to update an existing message
class UpdateMessageEvent extends ChatboxEvent {
  /// The updated message
  final Message message;

  /// Creates a new [UpdateMessageEvent] event
  const UpdateMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

/// **[新增]** Event to receive a new message from SignalR
class ReceiveMessageEvent extends ChatboxEvent {
  /// The message received from SignalR
  final Message message;

  /// Creates a new [ReceiveMessageEvent] event
  const ReceiveMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}
