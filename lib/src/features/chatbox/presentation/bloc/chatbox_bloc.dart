import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/chatbox_usecase.dart';
import '../../domain/entities/message_entity.dart';
import 'chatbox_state.dart';
import 'chatbox_event.dart';

class ChatboxBloc extends Bloc<ChatboxEvent, ChatboxState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final SendFile sendFile;
  final GetContactInfo getContactInfo;

  ChatboxBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.sendFile,
    required this.getContactInfo,
  }) : super(ChatboxInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<SendFileEvent>(_onSendFile);
    on<LoadContactInfo>(_onLoadContactInfo);
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatboxState> emit) async {
    emit(MessagesLoading());
    try {
      await emit.forEach(
        getMessages(event.contactId),
        onData: (List<Message> messages) => MessagesLoaded(messages),
      );
    } catch (e) {
      emit(ChatboxError(e.toString()));
    }
  }

  void _onSendMessage(
      SendMessageEvent event, Emitter<ChatboxState> emit) async {
    emit(MessageSending());
    try {
      await sendMessage(event.message);
      emit(MessageSent());
    } catch (e) {
      emit(ChatboxError(e.toString()));
    }
  }

  void _onSendFile(SendFileEvent event, Emitter<ChatboxState> emit) async {
    emit(MessageSending());
    try {
      await sendFile(event.path, event.type);
      emit(MessageSent());
    } catch (e) {
      emit(ChatboxError(e.toString()));
    }
  }

  void _onLoadContactInfo(
      LoadContactInfo event, Emitter<ChatboxState> emit) async {
    try {
      final contactInfo = await getContactInfo(event.contactId);
      emit(ContactInfoLoaded(contactInfo));
    } catch (e) {
      emit(ChatboxError(e.toString()));
    }
  }
}
