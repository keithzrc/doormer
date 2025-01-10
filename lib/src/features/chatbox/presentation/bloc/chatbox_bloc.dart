import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import '../../domain/usecase/chatbox_usecase.dart';
import '../../domain/entities/message_entity.dart';
import 'chatbox_state.dart';
import 'chatbox_event.dart';

/// Manages the chat box functionality and state.
///
/// This bloc handles message loading, sending messages, sending files,
/// and loading contact information. It maintains the state of the chat box
/// and processes various chat-related events.
class ChatboxBloc extends Bloc<ChatboxEvent, ChatboxState> {
  /// Use case for retrieving messages.
  final GetMessages getMessages;

  /// Use case for sending messages.
  final SendMessage sendMessage;

  /// Use case for sending files.
  final SendFile sendFile;

  /// Use case for retrieving contact information.
  final GetContactInfo getContactInfo;

  /// Creates a new instance of [ChatboxBloc].
  ///
  /// Requires all necessary use cases to be provided:
  /// - [getMessages] for retrieving messages
  /// - [sendMessage] for sending new messages
  /// - [sendFile] for sending files
  /// - [getContactInfo] for retrieving contact information
  ///
  /// Optionally accepts [initialMessages] to set the initial state.
  ChatboxBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.sendFile,
    required this.getContactInfo,
    List<Message>? initialMessages,
  }) : super(initialMessages != null 
            ? MessagesLoaded(initialMessages)
            : ChatboxInitial()) {
            
    /// Handles the loading of messages for a specific contact.
    ///
    /// Emits [MessagesLoading] while fetching messages and
    /// [MessagesLoaded] when messages are successfully loaded.
    on<LoadMessages>((event, emit) async {
      emit(MessagesLoading());
      try {
        await emit.forEach(
          getMessages(event.contactId),
          onData: (List<Message> messages) {
            AppLogger.debug('Messages loaded successfully');
            return MessagesLoaded(messages);
          },
        );
      } catch (e, stackTrace) {
        emit(ChatboxError(e.toString()));
        AppLogger.error('Messages loaded with error', e, stackTrace);
      }
    });

    /// Handles sending a new message.
    ///
    /// Emits [MessageSending] while sending the message and
    /// [MessageSent] when the message is successfully sent.
    on<SendMessageEvent>((event, emit) async {
      emit(MessageSending());
      try {
        await sendMessage(event.message);
        emit(MessageSent());
        AppLogger.debug('Message sent successfully');
      } catch (e, stackTrace) {
        emit(ChatboxError(e.toString()));
        AppLogger.error('Message sent with error', e, stackTrace);
      }
    });

    /// Handles sending a file.
    ///
    /// Emits [MessageSending] while sending the file and
    /// [MessageSent] when the file is successfully sent.
    on<SendFileEvent>((event, emit) async {
      emit(MessageSending());
      try {
        await sendFile(event.path, event.type);
        emit(MessageSent());
        AppLogger.debug('File sent successfully');
      } catch (e, stackTrace) {
        emit(ChatboxError(e.toString()));
        AppLogger.error('File sent with error', e, stackTrace);
      }
    });

    /// Handles loading contact information.
    ///
    /// Emits [ContactInfoLoaded] when contact information is successfully loaded.
    on<LoadContactInfo>((event, emit) async {
      AppLogger.info('Loading contact info for ID: ${event.contactId}');
      try {
        final contactInfo = await getContactInfo(event.contactId);
        AppLogger.debug('Contact info loaded successfully: ${contactInfo.name}');
        emit(ContactInfoLoaded(contactInfo));
      } catch (e, stackTrace) {
        AppLogger.error('Error loading contact info', e, stackTrace);
        emit(ChatboxError(e.toString()));
      }
    });
  }
}
