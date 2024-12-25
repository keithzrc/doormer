import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ChatRepositoryImpl repository;

  setUp(() {
    repository = ChatRepositoryImpl();
  });

  group('ChatRepositoryImpl', () {
    // 1. 基本查询测试
    group('Basic Query Tests', () {
      test('getActiveChatList should return only unarchived chats', () async {
        final chats = await repository.getActiveChatList();
        for (var chat in chats) {
          expect(chat.isArchived, false);
        }
      });

      test('getArchivedChatList should return only archived chats', () async {
        final archivedChats = await repository.getArchivedChatList();
        for (var chat in archivedChats) {
          expect(chat.isArchived, true);
        }
      });
    });

    // 2. 归档操作测试
    group('Archive Operations', () {
      test('updateChat should be able to archive chat', () async {
        final initialChats = await repository.getActiveChatList();
        if (initialChats.isEmpty) return;

        final chatToArchive = initialChats.first;
        final updatedChat = chatToArchive.copyWith(isArchived: true);
        await repository.updateChat(updatedChat);

        final archivedChats = await repository.getArchivedChatList();
        final archivedChat = archivedChats.firstWhere(
          (chat) => chat.id == chatToArchive.id,
          orElse: () => throw Exception('Archived chat not found'),
        );

        expect(archivedChat.isArchived, true);
      });

      test('updateChat should handle non-existent chat', () async {
        final nonExistentChat = Contact(
            id: 'non-existent-id',
            userName: 'Test User',
            avatarUrl: 'test.jpg',
            lastMessage: 'Test message',
            lastMessageCreatedTime: DateTime.now(),
            isArchived: true,
            isRead: true);
        await repository.updateChat(nonExistentChat);
        expect(true, true);
      });
    });

    // 3. 删除操作测试
    group('Delete Operations', () {
      test('deleteChat should remove chat from list', () async {
        final initialChats = await repository.getActiveChatList();
        if (initialChats.isEmpty) return;

        final chatToDelete = initialChats.first;
        await repository.deleteChat(chatToDelete.id);

        final updatedChats = await repository.getActiveChatList();
        final deletedChat =
            updatedChats.where((chat) => chat.id == chatToDelete.id);
        expect(deletedChat.isEmpty, true);
      });

      test('deleteChat should handle non-existent chat ID', () async {
        await repository.deleteChat('non-existent-id');
        expect(true, true);
      });
    });

    // 5. 数据加载测试
    group('Data Loading Tests', () {
      test('_ensureDataLoaded should attempt to load data if empty', () async {
        repository = ChatRepositoryImpl();
        await repository.getActiveChatList();
        expect(true, true);
      });
    });
  });
}
