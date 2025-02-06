import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import '../../domain/usecase/chatbox_usecase.dart';
import '../../domain/entities/message_entity.dart';
import 'chatbox_state.dart';
import 'chatbox_event.dart';
import 'package:doormer/src/core/signalr_service.dart';

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
  //final GetContactInfo getContactInfo;

  /// SignalR service for handling SignalR connections.
  final SignalRService signalRService;

  /// User ID for identifying messages.
  final String userId;

  /// Use case for handling received messages.
  final HandleReceivedMessage handleReceivedMessage;

  /// Creates a new instance of [ChatboxBloc].
  ///
  /// Requires all necessary use cases to be provided:
  /// - [getMessages] for retrieving messages
  /// - [sendMessage] for sending new messages
  /// - [sendFile] for sending files
  /// - [getContactInfo] for retrieving contact information
  /// - [signalRService] for handling SignalR connections
  /// - [userId] for identifying messages
  ///
  /// Optionally accepts [initialMessages] to set the initial state.
  ChatboxBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.sendFile,
    required this.handleReceivedMessage,
    //required this.getContactInfo,
    required this.signalRService,
    required this.userId,
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
            AppLogger.debug('Messages loaded successfully: ${messages.length} messages');
            return MessagesLoaded(messages);
          },
        );
      } catch (e) {
        AppLogger.error('Error loading messages', e);
        emit(ChatboxError(e.toString()));
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
      } catch (e) {
        AppLogger.error('Error sending message', e);
        emit(ChatboxError(e.toString()));
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
    // on<LoadContactInfo>((event, emit) async {
    //   AppLogger.info('Loading contact info for ID: ${event.contactId}');
    //   try {
    //     final contactInfo = await getContactInfo(event.contactId);
    //     AppLogger.debug(
    //         'Contact info loaded successfully: ${contactInfo.name}');
    //     emit(ContactInfoLoaded(contactInfo));
    //   } catch (e, stackTrace) {
    //     AppLogger.error('Error loading contact info', e, stackTrace);
    //     emit(ChatboxError(e.toString()));
    //   }
    // });

    /// **[新增]** Handles receiving a new message from SignalR.
    ///
    /// Adds the new message to the existing messages list and updates the state.
    on<ReceiveMessageEvent>((event, emit) async {
      try { handleReceivedMessage(event.message);
        if (state is MessagesLoaded) {
          final currentMessages = (state as MessagesLoaded).messages;
          
          // 检查消息是否已存在
          final messageExists = currentMessages.any((m) => m.id == event.message.id);
          if (!messageExists) {
            final updatedMessages = List<Message>.from(currentMessages)..add(event.message);
            
            // 按时间戳排序
            updatedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            
            emit(MessagesLoaded(updatedMessages));
            AppLogger.info('New message received and state updated: ${event.message.content}');
          }
        } else {
          // 如果当前没有加载消息，获取完整的消息历史
          final messages = await getMessages(event.message.contactId).first;
          final updatedMessages = List<Message>.from(messages);
          
          // 检查新消息是否已存在
          if (!updatedMessages.any((m) => m.id == event.message.id)) {
            updatedMessages.add(event.message);
            // 按时间戳排序
            updatedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          }
          
          emit(MessagesLoaded(updatedMessages));
        }
      } catch (e) {
        AppLogger.error('Error handling received message', e);
        emit(ChatboxError(e.toString()));
      }
    });

    // 在构造函数中设置 SignalR 消息处理
   // _setupSignalRHandler();
  }

  // void _setupSignalRHandler() {
  //   AppLogger.info("Setting up ReceieveMessage PRC call");
  //   signalRService.hubConnection.on("ReceiveMessage", (List<Object?>? args) {
  //     AppLogger.info("Receiving message: ${args?.toString()}");
  //     if (args != null && args.length >= 2) {
  //       try {
  //         final message = Message(
  //           id: DateTime.now().toString(),
  //           content: args[1]?.toString() ?? '',
  //           timestamp: DateTime.now(),
  //           isFromMe: args[0]?.toString() == userId,
  //           type: MessageType.text,
  //           contactId: args[0]?.toString() ?? '',
  //         );
  //         add(ReceiveMessageEvent(message));
  //         AppLogger.debug('Message created and event added successfully');
  //       } catch (e) {
  //         AppLogger.error('Error creating message from SignalR args', e);
  //       }
  //     } else {
  //       AppLogger.error('Received invalid SignalR message format');
  //     }
  //   });
  // }

  @override
  Future<void> close() {
    // 清理 SignalR 处理器
    signalRService.hubConnection.off("ReceiveMessage");
    return super.close();
  }
}
