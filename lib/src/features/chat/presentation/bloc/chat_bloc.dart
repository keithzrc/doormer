import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'chat_event.dart';
import 'chat_state.dart';

// TODO: split archive and centralized.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetSortedActiveChatList getChatListUseCase;
  final GetSortedArchivedChatList getArchivedChatListUseCase;
  final ToggleChatArchivedStatus toggleChatUseCase;
  final DeleteChat deleteChatUseCase;

  ChatBloc({
    required this.getChatListUseCase,
    required this.getArchivedChatListUseCase,
    required this.toggleChatUseCase,
    required this.deleteChatUseCase,
    List<Contact>? initialChats,
  }) : super(initialChats != null
            ? ChatLoadedState(
                unarchivedChats: initialChats.where((chat) => !chat.isArchived).toList(),
                archivedChats: initialChats.where((chat) => chat.isArchived).toList(),
              )
            : ChatLoadingState()) {
    on<LoadChatsEvent>((_, emit) async {
      emit(ChatLoadingState());
      try {
        final chats = await getChatListUseCase.call();
        final archivedChats = await getArchivedChatListUseCase.call();
        AppLogger.debug('Loaded chats: ${chats.length}, archived: ${archivedChats.length}');
        emit(ChatLoadedState(
          unarchivedChats: chats,
          archivedChats: archivedChats,
        ));
      } catch (e, stack) {
        AppLogger.error('Error loading chats', e, stack);
        emit(ChatErrorState(e.toString()));
      }
    });

    on<LoadArchivedChatsEvent>((event, emit) async {
      emit(ChatLoadingState());
      try {
        final chats = await getChatListUseCase.call();
        final archivedChats = await getArchivedChatListUseCase.call();
        emit(ChatLoadedState(
          unarchivedChats: chats,
          archivedChats: archivedChats,
        ));
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

    // TODO: use routes
    on<ToggleArchiveStatusEvent>((event, emit) async {
      try {
        await toggleChatUseCase.call(event.contact);
        add(LoadChatsEvent());
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

    
  }
}
