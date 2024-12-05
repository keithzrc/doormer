import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/archive_chat.dart';
import '../../domain/usecases/delete_chat.dart';
import '../../domain/usecases/get_chat_list.dart';
import '../../domain/usecases/get_archived_list.dart';
import '../../domain/entities/chat_entity.dart';

abstract class ChatEvent {}

class LoadChatsEvent extends ChatEvent {}

class LoadArchivedChatsEvent extends ChatEvent {}

class ArchiveChatEvent extends ChatEvent {
  final String chatId;
  ArchiveChatEvent(this.chatId);
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  DeleteChatEvent(this.chatId);
}

abstract class ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Chat> chats;
  ChatLoadedState(this.chats);
}

class ArchivedChatLoadedState extends ChatState {
  final List<Chat> archivedChats;
  ArchivedChatLoadedState(this.archivedChats);
}

class ChatErrorState extends ChatState {}

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
      } catch (e) {
        emit(ChatErrorState());
      }
    });
    on<LoadArchivedChatsEvent>((event, emit) async {
      emit(ChatLoadingState());
      try {
        final archivedChats = await getArchivedChatList.call();
        emit(ArchivedChatLoadedState(archivedChats));
      } catch (e) {
        emit(ChatErrorState());
      }
    });

    on<ArchiveChatEvent>((event, emit) async {
      try {
        await archiveChat.call(event.chatId);
        add(LoadChatsEvent());
      } catch (e) {
        emit(ChatErrorState());
      }
    });

    on<DeleteChatEvent>((event, emit) async {
      try {
        await deleteChat.call(event.chatId);
        add(LoadArchivedChatsEvent());
      } catch (e) {
        emit(ChatErrorState());
      }
    });
  }
}
