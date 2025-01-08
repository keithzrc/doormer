import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:doormer/src/features/chat/data/repositories/file/chat_repo_impl.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';
import 'chat_repo_impl_test.mocks.dart';

@GenerateMocks([LocalDataSource])
void main() {
  late ChatRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late List<ContactModel> mockContacts;
  late UuidValue testId1;
  late UuidValue testId2;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
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
        
    repository = ChatRepositoryImpl(localDataSource: mockLocalDataSource);
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
  });
}
