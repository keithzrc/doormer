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
    on<LoadContactInfo>((event, emit) async {
      try {
        print('Loading contact info for ID: ${event.contactId}');
        final contactInfo = await getContactInfo(event.contactId);
        print('Contact info loaded successfully: ${contactInfo.name}');
        emit(ContactInfoLoaded(contactInfo));
        print('Emitted ContactInfoLoaded state');
      } catch (e) {
        print('Error loading contact info: $e');
        emit(ChatboxError(e.toString()));
      }
    });
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

  void resetState() {
    emit(ChatboxInitial());
  }

  @override
  void onTransition(Transition<ChatboxEvent, ChatboxState> transition) {
    super.onTransition(transition);
    print('ChatboxBloc transition: $transition');
  }

  @override
  void onChange(Change<ChatboxState> change) {
    super.onChange(change);
    print('ChatboxBloc state changed: ${change.currentState} -> ${change.nextState}');
  }

  @override
  Future<void> close() async {
    print('Closing ChatboxBloc');
    await super.close();
  }
}
