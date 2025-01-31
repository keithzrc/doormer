import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/datasources/remote_data_source.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';
import 'chat_repo_impl_test.mocks.dart';

@GenerateMocks([LocalDataSource, ChatRemoteDataSource])
void main() {
  late ChatRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockChatRemoteDataSource mockRemoteDataSource;
  late List<ContactModel> mockContacts;
  late UuidValue testId1;
  late UuidValue testId2;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockChatRemoteDataSource();
    testId1 = UuidValue(const Uuid().v4());
    testId2 = UuidValue(const Uuid().v4());
    
    mockContacts = [
      ContactModel(
        id: testId1,
        userName: 'Active User',
        avatarUrl: 'https://example.com/avatar1.png',
        lastMessage: 'Hello',
        lastMessageCreatedTime: DateTime.now(),
        isArchived: false,
        isRead: true,
      ),
      ContactModel(
        id: testId2,
        userName: 'Archived User',
        avatarUrl: 'https://example.com/avatar2.png',
        lastMessage: 'Hi',
        lastMessageCreatedTime: DateTime.now(),
        isArchived: true,
        isRead: false,
      ),
    ];

    when(mockLocalDataSource.loadDummyData())
        .thenAnswer((_) async => mockContacts);
    
    // 添加 remoteDataSource 的基本 mock
    when(mockRemoteDataSource.archiveChat(any, any, any))
        .thenAnswer((_) async => {});

    when(mockRemoteDataSource.updateChat(any))
        .thenAnswer((_) async => {});
        
    repository = ChatRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      tokenStorage: mockTokenStorage,
    );
  });

  group('ChatRepositoryImpl', () {
    test('should initialize data on construction', () {
      verify(mockLocalDataSource.loadDummyData()).called(1);
    });

    test('getActiveChatList should return only active chats', () async {
      final result = await repository.getActiveChatList();
      expect(result.length, 1);
      expect(result.first.userName, 'Active User');
      expect(result.first.isArchived, false);
    });

    test('getArchivedChatList should return only archived chats', () async {
      final result = await repository.getArchivedChatList();
      expect(result.length, 1);
      expect(result.first.userName, 'Archived User');
      expect(result.first.isArchived, true);
    });

    test('updateChat should update existing chat', () async {
      final updatedContact = Contact(
        id: testId1,
        userName: 'Updated User',
        avatarUrl: 'https://example.com/avatar1.png',
        lastMessage: 'Hello',
        lastMessageCreatedTime: DateTime.now(),
        isArchived: true,
        isRead: true,
      );

      await repository.updateChat(updatedContact);
      final archivedChats = await repository.getArchivedChatList();
      
      expect(archivedChats.any((chat) => 
        chat.id == testId1 && 
        chat.userName == 'Updated User' &&
        chat.isArchived
      ), isTrue);
    });

    test('deleteChat should remove chat from list', () async {
      await repository.deleteChat(testId1.toString());
      final activeChats = await repository.getActiveChatList();
      expect(activeChats.any((chat) => chat.id == testId1), isFalse);
    });

    test('should handle empty data', () async {
      when(mockLocalDataSource.loadDummyData())
          .thenAnswer((_) async => []);

      final newRepository = ChatRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource,
      );

      final activeChats = await newRepository.getActiveChatList();
      final archivedChats = await newRepository.getArchivedChatList();

      expect(activeChats, isEmpty);
      expect(archivedChats, isEmpty);
    });

    test('should handle initialization failure', () async {
      reset(mockLocalDataSource);
      when(mockLocalDataSource.loadDummyData())
          .thenAnswer((_) => Future.error(Exception('Failed to load')));

      final repo = ChatRepositoryImpl(localDataSource: mockLocalDataSource);
      await Future.delayed(Duration.zero);

      final activeChats = await repo.getActiveChatList();
      expect(activeChats, isEmpty);
    });

    test('updateChat should handle non-existent chat', () async {
      final nonExistentContact = Contact(
        id: UuidValue(const Uuid().v4()),
        userName: 'Non-existent User',
        avatarUrl: 'https://example.com/avatar.png',
        lastMessage: 'Hello',
        lastMessageCreatedTime: DateTime.now(),
        isArchived: false,
        isRead: true,
      );

      await repository.updateChat(nonExistentContact);
      final allChats = await Future.wait([
        repository.getActiveChatList(),
        repository.getArchivedChatList(),
      ]);
      final flattenedChats = allChats.expand((x) => x).toList();
      
      expect(flattenedChats.any((chat) => chat.id == nonExistentContact.id), isFalse);
    });

    test('deleteChat should handle non-existent chat ID', () async {
      final nonExistentId = const Uuid().v4();
      final initialActiveChats = await repository.getActiveChatList();
      final initialArchivedChats = await repository.getArchivedChatList();
      
      await repository.deleteChat(nonExistentId);
      
      final finalActiveChats = await repository.getActiveChatList();
      final finalArchivedChats = await repository.getArchivedChatList();
      
      expect(finalActiveChats.length, equals(initialActiveChats.length));
      expect(finalArchivedChats.length, equals(initialArchivedChats.length));
    });

    test('should maintain data consistency after multiple operations', () async {
      final initialActiveChats = await repository.getActiveChatList();
      
      final chatToArchive = initialActiveChats.first;
      final archivedChat = Contact(
        id: chatToArchive.id,
        userName: chatToArchive.userName,
        avatarUrl: chatToArchive.avatarUrl,
        lastMessage: chatToArchive.lastMessage,
        lastMessageCreatedTime: chatToArchive.lastMessageCreatedTime,
        isArchived: true,
        isRead: chatToArchive.isRead,
      );
      
      await repository.updateChat(archivedChat);
      
      final activeChatsAfterArchive = await repository.getActiveChatList();
      final archivedChatsAfterArchive = await repository.getArchivedChatList();
      
      expect(activeChatsAfterArchive.length, equals(initialActiveChats.length - 1));
      expect(archivedChatsAfterArchive.any((chat) => chat.id == chatToArchive.id), isTrue);
      
      await repository.deleteChat(chatToArchive.id.toString());
      
      final finalArchivedChats = await repository.getArchivedChatList();
      expect(finalArchivedChats.any((chat) => chat.id == chatToArchive.id), isFalse);
    });

    test('should handle concurrent operations correctly', () async {
      await Future.wait([
        repository.getActiveChatList(),
        repository.getArchivedChatList(),
        repository.updateChat(mockContacts.first.toEntity()),
        repository.deleteChat(mockContacts.last.id.toString()),
      ]);

      final activeChats = await repository.getActiveChatList();
      final archivedChats = await repository.getArchivedChatList();
      
      expect(activeChats.length + archivedChats.length, equals(mockContacts.length - 1));
    });

    test('archiveChat should update local and remote data', () async {
      await repository.archiveChat(testId1, testId1, true);
      
      // 验证本地数据更新
      final archivedChats = await repository.getArchivedChatList();
      expect(archivedChats.any((chat) => chat.id == testId1), isTrue);
      
      // 验证远程调用
      verify(mockRemoteDataSource.archiveChat(testId1, testId1, true)).called(1);
    });

    test('archiveChat should handle remote errors gracefully', () async {
      when(mockRemoteDataSource.archiveChat(any, any, any))
          .thenThrow(Exception('Network error'));

      try {
        await repository.archiveChat(testId1, testId1, true);
        fail('Should throw an exception');
      } catch (e) {
        expect(e, isInstanceOf<Exception>());
      }
    });
  });
}
