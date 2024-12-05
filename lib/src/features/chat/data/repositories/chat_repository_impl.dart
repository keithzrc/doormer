import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final List<ChatModel> _chats = [
    ChatModel(
      id: '1',
      userName: 'User 1',
      avatarUrl: 'https://example.com/avatar1.png',
      lastMessage: 'Hello',
      lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
      isArchived: true,
    ),
    ChatModel(
      id: '2',
      userName: 'User 2',
      avatarUrl: 'https://example.com/avatar2.png',
      lastMessage: 'Hi',
      lastMessageTime: DateTime.now().subtract(Duration(days: 15)),
      isArchived: true,
    ),
  ];

  @override
  Future<List<Chat>> getChatList() async {
    return _chats.where((chat) => !chat.isArchived).toList();
  }

  @override
  Future<List<Chat>> getArchivedList() async {
    return _chats.where((chat) => chat.isArchived).toList();
  }

  @override
  Future<void> archiveChat(String chatId) async {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      final chat = _chats[index];

      _chats[index] = ChatModel(
        id: chat.id,
        userName: chat.userName,
        avatarUrl: chat.avatarUrl,
        lastMessage: chat.lastMessage,
        lastMessageTime: chat.lastMessageTime,
        isArchived: true,
      );
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    _chats.removeWhere((chat) => chat.id == chatId);
  }

  Future<void> autoArchiveInactiveChats(Duration threshold) async {
    final now = DateTime.now();
    for (int i = 0; i < _chats.length; i++) {
      final chat = _chats[i];
      if (!chat.isArchived &&
          now.difference(chat.lastMessageTime) > threshold) {
        _chats[i] = ChatModel(
          id: chat.id,
          userName: chat.userName,
          avatarUrl: chat.avatarUrl,
          lastMessage: chat.lastMessage,
          lastMessageTime: chat.lastMessageTime,
          isArchived: true,
        );
      }
    }
  }
}
