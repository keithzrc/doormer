// chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import '../../domain/usecases/archive_chat.dart';
import '../../domain/usecases/delete_chat.dart';
import '../../domain/usecases/get_chat_list.dart';
import '../../domain/usecases/get_archived_list.dart';
import 'archive_event.dart';
import 'archive_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatList getChatList;
  final GetArchivedList getArchivedChatList;
  final ArchiveChat archiveChat;
  final DeleteChat deleteChat;

  ChatBloc({
    required this.getChatList,
    required this.getArchivedChatList,
    required this.archiveChat,
    required this.deleteChat,
  }) : super(ChatLoadingState()) {
    on<LoadChatsEvent>((event, emit) async {
      emit(ChatLoadingState());
      try {
        final chats = await getChatList.call();
        emit(ChatLoadedState(chats));
        AppLogger.info('Chat list loaded successfully');
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Chat list loaded with error', e, stackTrace);
      }
    });

    on<LoadArchivedChatsEvent>((event, emit) async {
      emit(ChatLoadingState());
      try {
        final archivedChats = await getArchivedChatList.call();
        emit(ArchivedChatLoadedState(archivedChats));
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Archived chat list loaded with error', e, stackTrace);
      }
    });

    on<ArchiveChatEvent>((event, emit) async {
      try {
        await archiveChat.call(event.chatId);
        add(LoadChatsEvent());
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Archived chat with error', e, stackTrace);
      }
    });

    on<DeleteChatEvent>((event, emit) async {
      try {
        await deleteChat.call(event.chatId);
        add(LoadArchivedChatsEvent());
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Deleted chat with error', e, stackTrace);
      }
    });
  }
}
