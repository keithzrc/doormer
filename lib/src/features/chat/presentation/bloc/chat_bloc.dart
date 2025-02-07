import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:uuid/uuid.dart';
import 'chat_event.dart';
import 'chat_state.dart';

// TODO: get user id from token as we do not have token and auth implemented yet
// we will use a fixed ID.

// TODO: split archive and centralized.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetSortedActiveChatList getChatListUseCase;
  final GetSortedArchivedChatList getArchivedChatListUseCase;
  final ToggleChatArchivedStatus toggleChatUseCase;
  final String userId;

  ChatBloc({
    required this.getChatListUseCase,
    required this.getArchivedChatListUseCase,
    required this.toggleChatUseCase,
    required this.userId,
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
        final chats = await getChatListUseCase.call(UuidValue(userId));
        final archivedChats = await getArchivedChatListUseCase.call(UuidValue(userId));
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
        final chats = await getChatListUseCase.call(UuidValue(userId));
        final archivedChats = await getArchivedChatListUseCase.call(UuidValue(userId));
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
        await toggleChatUseCase.call(UuidValue(userId), event.contact);
        add(LoadChatsEvent());
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });
  }
}
