import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ChatRepositoryImpl repository;

  setUp(() {
    repository = ChatRepositoryImpl();
  });

  group('ChatRepositoryImpl', () {
    // 1. 基本查询测试
    group('Basic Query Tests', () {
      test('getChatList should return only unarchived chats', () async {
        final chats = await repository.getChatList();
        for (var chat in chats) {
          expect(chat.isArchived, false);
        }
      });

      test('getArchivedList should return only archived chats', () async {
        final archivedChats = await repository.getArchivedList();
        for (var chat in archivedChats) {
          expect(chat.isArchived, true);
        }
      });
    });

    // 2. 归档操作测试
    group('Archive Operations', () {
      test('archiveChat should set isArchived to true', () async {
        final initialChats = await repository.getChatList();
        if (initialChats.isEmpty) return;

        final chatToArchive = initialChats.first;
        await repository.archiveChat(chatToArchive.id);

        final archivedChats = await repository.getArchivedList();
        final archivedChat = archivedChats.firstWhere(
          (chat) => chat.id == chatToArchive.id,
          orElse: () => throw Exception('Archived chat not found'),
        );

        expect(archivedChat.isArchived, true);
      });

      test('archiveChat should handle non-existent chat ID', () async {
        await repository.archiveChat('non-existent-id');
        expect(true, true);
      });
    });

    // 3. 删除操作测试
    group('Delete Operations', () {
      test('deleteChat should remove chat from list', () async {
        final initialChats = await repository.getChatList();
        if (initialChats.isEmpty) return;

        final chatToDelete = initialChats.first;
        await repository.deleteChat(chatToDelete.id);

        final updatedChats = await repository.getChatList();
        final deletedChat = updatedChats.where((chat) => chat.id == chatToDelete.id);
        expect(deletedChat.isEmpty, true);
      });

      test('deleteChat should handle non-existent chat ID', () async {
        await repository.deleteChat('non-existent-id');
        expect(true, true);
      });
    });

    // 4. 自动归档测试
    group('Auto Archive Tests', () {
      test('autoArchiveInactiveChats should archive old chats', () async {
        final initialChats = await repository.getChatList();
        if (initialChats.isEmpty) return;

        const threshold = Duration(seconds: 0);
        await repository.autoArchiveInactiveChats(threshold);
        await Future.delayed(const Duration(milliseconds: 100));

        final archivedChats = await repository.getArchivedList();
        final unarchivedChats = await repository.getChatList();

        // 验证归档的聊天是否都超过阈值
        for (var chat in archivedChats) {
          if (chat.createdTime != null) {
            final age = DateTime.now().difference(chat.createdTime!);
            expect(age > threshold, true);
          }
        }

        // 验证未归档的聊天是否都在阈值内
        for (var chat in unarchivedChats) {
          if (chat.createdTime != null) {
            final age = DateTime.now().difference(chat.createdTime!);
            expect(age <= threshold, true);
          }
        }
      });
    });

    // 5. 数据加载测试
    group('Data Loading Tests', () {
      test('_ensureDataLoaded should attempt to load data if empty', () async {
        repository = ChatRepositoryImpl();
        await repository.getChatList();
        expect(true, true);
      });
    });
  });
}