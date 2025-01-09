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
            ? ChatLoadedState(chats: initialChats, archivedChats: [])
            : ChatLoadingState()) {
    on<LoadChatsEvent>((event, emit) async {
      emit(ChatLoadingState());
      try {
        final chats = await getChatListUseCase.call();
        final archivedChats = await getArchivedChatListUseCase.call();
        AppLogger.debug('Loaded chats: ${chats.length}, archived: ${archivedChats.length}');
        emit(ChatLoadedState(
          chats: chats.where((chat) => !chat.isArchived).toList(),
          archivedChats: archivedChats.where((chat) => chat.isArchived).toList(),
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
          chats: chats,
          archivedChats: archivedChats,
        ));
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

    // TODO: use routes
    on<ToggleChatEvent>((event, emit) async {
      try {
        await toggleChatUseCase.call(event.contact);
        add(LoadChatsEvent());
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

    on<DeleteChatEvent>((event, emit) async {
      try {
        await deleteChatUseCase.call(event.chatId);
        add(LoadArchivedChatsEvent());
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Deleted chat with error', e, stackTrace);
      }
    });
  }
}
