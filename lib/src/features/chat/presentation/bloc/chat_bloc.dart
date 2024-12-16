// archieve_bloc.dart
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatArchiveBloc extends Bloc<ChatEvent, ChatState> {
  final GetUnarchivedchatList getChatListUseCase;
  final GetArchivedList getArchivedChatListUseCase;
  final ToggleChat toggleChatUseCase;
  final DeleteChat deleteChatUseCase;

  ChatArchiveBloc({
    required this.getChatListUseCase,
    required this.getArchivedChatListUseCase,
    required this.toggleChatUseCase,
    required this.deleteChatUseCase,
    List<Contact>? initialChats,
  }) : super(initialChats != null //simple logic so kept here
            ? ChatLoadedState(initialChats)
            : ChatLoadingState()) {
    on<LoadChatsEvent>((_, emit) async {
      emit(ChatLoadingState());
      try {
        final chats = await getChatListUseCase.call();
        emit(ChatLoadedState(chats));
        AppLogger.debug('Chat list loaded successfully');
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Chat list loaded with error', e, stackTrace);
      }
    });

    on<LoadArchivedChatsEvent>((event, emit) async {
      emit(ArchivedChatLoadingState());
      try {
        final archivedChats = await getArchivedChatListUseCase.call();
        emit(ArchivedChatLoadedState(archivedChats));
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Archived chat list loaded with error', e, stackTrace);
      }
    });

    on<ToggleChatEvent>((event, emit) async {
      try {
        if (state is ChatLoadedState) {
          add(LoadChatsEvent()); // Reload normal chat list
        } else if (state is ArchivedChatLoadedState) {
          add(LoadArchivedChatsEvent()); // Reload archived chat list
        }
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Error toggling chat archive state', e, stackTrace);
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
