import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/contact_info_entity.dart';

/// Base class for all chatbox states
abstract class ChatboxState extends Equatable {
  /// Creates a new instance of [ChatboxState]
  const ChatboxState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the chatbox
class ChatboxInitial extends ChatboxState {
  /// Creates a new instance of [ChatboxInitial]
  const ChatboxInitial();
}

/// State when messages are being loaded
class MessagesLoading extends ChatboxState {
  /// Creates a new instance of [MessagesLoading]
  const MessagesLoading();
}

/// State when messages have been loaded successfully
class MessagesLoaded extends ChatboxState {
  /// The list of loaded messages
  final List<Message> messages;

  /// Creates a new instance of [MessagesLoaded]
  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// State when a message is being sent
class MessageSending extends ChatboxState {
  /// Creates a new instance of [MessageSending]
  const MessageSending();
}

/// State when a message has been sent successfully
class MessageSent extends ChatboxState {
  /// Creates a new instance of [MessageSent]
  const MessageSent();
}

/// State when a message has been sent successfully
class MessageReceived extends ChatboxState {
  /// Creates a new instance of [MessageReceive]
  const MessageReceived();
}

/// State when contact information has been loaded successfully
class ContactInfoLoaded extends ChatboxState {
  /// The loaded contact information
  final ContactInfo contactInfo;

  /// Creates a new instance of [ContactInfoLoaded]
  const ContactInfoLoaded(this.contactInfo);

  @override
  List<Object?> get props => [contactInfo];
}

/// State when an error occurs in the chatbox
class ChatboxError extends ChatboxState {
  /// The error message
  final String error;

  /// Creates a new instance of [ChatboxError]
  const ChatboxError(this.error);

  @override
  List<Object?> get props => [error];
}
