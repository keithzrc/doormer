import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:uuid/uuid.dart';
import 'chat_event.dart';
import 'chat_state.dart';

// TODO: get user id from token as we do not have token and auth implemented yet
// we will use a fixed ID.
UuidValue userId = UuidValue('3fa85f64-5717-4562-b3fc-2c963f66afa7');

// TODO: split archive and centralized.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetSortedActiveChatList getChatListUseCase;
  final GetSortedArchivedChatList getArchivedChatListUseCase;
  final ToggleChatArchivedStatus toggleChatUseCase;
  //final DeleteChat deleteChatUseCase;
  final GetUnreadMessageCount getUnreadMessageCountUseCase;

  ChatBloc({
    required this.getChatListUseCase,
    required this.getArchivedChatListUseCase,
    required this.toggleChatUseCase,
    //required this.deleteChatUseCase,
    required this.getUnreadMessageCountUseCase,
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
        final chats = await getChatListUseCase.call(userId);
        final archivedChats = await getArchivedChatListUseCase.call(userId);
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
        final chats = await getChatListUseCase.call(userId);
        final archivedChats = await getArchivedChatListUseCase.call(userId);
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
        await toggleChatUseCase.call(userId, event.contact);
        add(LoadChatsEvent());
      } catch (e) {
        emit(ChatErrorState(e.toString()));
      }
    });

//     on<DeleteChatEvent>((event, emit) async {
//       try {
//         await deleteChatUseCase.call(event.chatId);
//         add(LoadArchivedChatsEvent());
//       } catch (e, stackTrace) {
//         emit(ChatErrorState(e.toString()));
//         AppLogger.error('Deleted chat with error', e, stackTrace);
//       }
//     });

    on<LoadUnreadMessageCountEvent>((event, emit) async {
      emit(UnreadMessageCountLoadingState());
      try {
        final count = await getUnreadMessageCountUseCase.call(event.contactId);
        emit(UnreadMessageCountLoadedState(count));
        AppLogger.info('Unread message count loaded successfully');
      } catch (e, stackTrace) {
        emit(ChatErrorState(e.toString()));
        AppLogger.error('Failed to load unread message count', e, stackTrace);
      }
    });
  }
}
