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
    ChatModel(
      id: '3',
      userName: 'User 3',
      avatarUrl: 'https://example.com/avatar3.png',
      lastMessage: 'How are you?',
      lastMessageTime: DateTime.now().subtract(Duration(days: 3)),
      isArchived: false,
    ),
    ChatModel(
      id: '4',
      userName: 'User 4',
      avatarUrl: 'https://example.com/avatar4.png',
      lastMessage: 'Are you there?',
      lastMessageTime: DateTime.now().subtract(Duration(hours: 5)),
      isArchived: true,
    ),
    ChatModel(
      id: '5',
      userName: 'User 5',
      avatarUrl: 'https://example.com/avatar5.png',
      lastMessage: 'Let’s catch up!',
      lastMessageTime: DateTime.now().subtract(Duration(days: 7)),
      isArchived: false,
    ),
    ChatModel(
      id: '6',
      userName: 'User 6',
      avatarUrl: 'https://example.com/avatar6.png',
      lastMessage: 'See you soon!',
      lastMessageTime: DateTime.now().subtract(Duration(days: 10)),
      isArchived: true,
    ),
    ChatModel(
      id: '7',
      userName: 'User 7',
      avatarUrl: 'https://example.com/avatar7.png',
      lastMessage: 'Can you help me with this?',
      lastMessageTime: DateTime.now().subtract(Duration(minutes: 30)),
      isArchived: false,
    ),
    ChatModel(
      id: '8',
      userName: 'User 8',
      avatarUrl: 'https://example.com/avatar8.png',
      lastMessage: 'Good morning!',
      lastMessageTime: DateTime.now().subtract(Duration(days: 2)),
      isArchived: true,
    ),
    ChatModel(
      id: '9',
      userName: 'User 9',
      avatarUrl: 'https://example.com/avatar9.png',
      lastMessage: 'Let me know.',
      lastMessageTime: DateTime.now().subtract(Duration(days: 1, hours: 5)),
      isArchived: true,
    ),
    ChatModel(
      id: '10',
      userName: 'User 10',
      avatarUrl: 'https://example.com/avatar10.png',
      lastMessage: 'Thanks!',
      lastMessageTime: DateTime.now().subtract(Duration(hours: 1)),
      isArchived: false,
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
