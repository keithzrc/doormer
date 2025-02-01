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

@GenerateMocks([ChatRemoteDataSource])
void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDataSource mockRemoteDataSource;
  late UuidValue testId;
  late UuidValue userId;
  late ContactModel testContactModel;

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    testId = UuidValue(const Uuid().v4());
    userId = UuidValue(const Uuid().v4());
    
    testContactModel = ContactModel(
      id: testId,
      userName: 'Test User',
      avatarUrl: 'https://example.com/avatar.jpg',
      lastMessage: 'Hello World',
      lastMessageCreatedTime: DateTime.now(),
      isArchived: false,
      isRead: true,
    );

    repository = ChatRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('getActiveChatList', () {
    test('should return list of active contacts when remote call is successful', () async {
      when(mockRemoteDataSource.getActiveChatList(userId))
          .thenAnswer((_) async => [testContactModel]);

      final result = await repository.getActiveChatList(userId);

      verify(mockRemoteDataSource.getActiveChatList(userId)).called(1);
      expect(result.length, 1);
      expect(result.first.id, equals(testId));
    });

    test('should throw exception when remote call fails', () async {
      when(mockRemoteDataSource.getActiveChatList(userId))
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.getActiveChatList(userId),
        throwsException,
      );
    });
  });

  group('getArchivedChatList', () {
    test('should return list of archived contacts when remote call is successful', () async {
      when(mockRemoteDataSource.getArchivedChatList(userId))
          .thenAnswer((_) async => [testContactModel]);

      final result = await repository.getArchivedChatList(userId);

      verify(mockRemoteDataSource.getArchivedChatList(userId)).called(1);
      expect(result.length, 1);
      expect(result.first.id, equals(testId));
    });

    test('should throw exception when remote call fails', () async {
      when(mockRemoteDataSource.getArchivedChatList(userId))
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.getArchivedChatList(userId),
        throwsException,
      );
    });
  });

  group('updateChat', () {
    test('should update chat successfully', () async {
      final contact = Contact(
        id: testId,
        userName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        lastMessage: 'Hello World',
        lastMessageCreatedTime: DateTime.now(),
        isArchived: false,
        isRead: true,
      );

      when(mockRemoteDataSource.updateChat(any))
          .thenAnswer((_) async => {});

      await repository.updateChat(contact);

      verify(mockRemoteDataSource.updateChat(any)).called(1);
    });

    test('should throw exception when update fails', () async {
      final contact = Contact(
        id: testId,
        userName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        lastMessage: 'Hello World',
        lastMessageCreatedTime: DateTime.now(),
        isArchived: false,
        isRead: true,
      );

      when(mockRemoteDataSource.updateChat(any))
          .thenThrow(Exception('Update failed'));

      expect(
        () => repository.updateChat(contact),
        throwsException,
      );
    });
  });

  group('archiveChat', () {
    test('should archive chat successfully', () async {
      when(mockRemoteDataSource.archiveChat(userId, testId, true))
          .thenAnswer((_) async => {});

      await repository.archiveChat(userId, testId, true);

      verify(mockRemoteDataSource.archiveChat(userId, testId, true)).called(1);
    });

    test('should throw exception when archive operation fails', () async {
      when(mockRemoteDataSource.archiveChat(userId, testId, true))
          .thenThrow(Exception('Archive failed'));

      expect(
        () => repository.archiveChat(userId, testId, true),
        throwsException,
      );
    });
  });
}

