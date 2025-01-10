import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

@GenerateNiceMocks([MockSpec<ContactRepository>()])
import 'contact_repository_test.mocks.dart';

void main() {
  group('ContactRepository', () {
    late MockContactRepository repository;
    late Contact testContact;
    final testUuid = UuidValue(const Uuid().v4());
    final testDateTime = DateTime.parse('2024-01-01T12:00:00.000Z');

    setUp(() {
      repository = MockContactRepository();
      testContact = Contact(
        id: testUuid,
        userName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        lastMessage: 'Hello World',
        lastMessageCreatedTime: testDateTime,
        isArchived: false,
        isRead: true,
      );
    });

    group('getActiveChatList', () {
      test('should return list of active chats', () async {
        when(repository.getActiveChatList())
            .thenAnswer((_) async => [testContact]);

        final result = await repository.getActiveChatList();

        expect(result, isA<List<Contact>>());
        expect(result.length, equals(1));
        expect(result.first, equals(testContact));
        verify(repository.getActiveChatList()).called(1);
      });

      test('should return empty list when no active chats', () async {
        when(repository.getActiveChatList())
            .thenAnswer((_) async => []);

        final result = await repository.getActiveChatList();

        expect(result, isEmpty);
        verify(repository.getActiveChatList()).called(1);
      });
    });

    group('getArchivedChatList', () {
      test('should return list of archived chats', () async {
        final archivedContact = testContact.copyWith(isArchived: true);
        when(repository.getArchivedChatList())
            .thenAnswer((_) async => [archivedContact]);

        final result = await repository.getArchivedChatList();

        expect(result, isA<List<Contact>>());
        expect(result.length, equals(1));
        expect(result.first.isArchived, isTrue);
        verify(repository.getArchivedChatList()).called(1);
      });

      test('should return empty list when no archived chats', () async {
        when(repository.getArchivedChatList())
            .thenAnswer((_) async => []);

        final result = await repository.getArchivedChatList();

        expect(result, isEmpty);
        verify(repository.getArchivedChatList()).called(1);
      });
    });

    group('updateChat', () {
      test('should update chat successfully', () async {
        when(repository.updateChat(testContact))
            .thenAnswer((_) async => {});

        await repository.updateChat(testContact);

        verify(repository.updateChat(testContact)).called(1);
      });

      test('should handle update failure', () async {
        when(repository.updateChat(testContact))
            .thenThrow(Exception('Update failed'));

        expect(
          () => repository.updateChat(testContact),
          throwsException,
        );
        verify(repository.updateChat(testContact)).called(1);
      });
    });

    group('deleteChat', () {
      test('should delete chat successfully', () async {
        final chatId = testUuid.toString();
        when(repository.deleteChat(chatId))
            .thenAnswer((_) async => {});

        await repository.deleteChat(chatId);

        verify(repository.deleteChat(chatId)).called(1);
      });

      test('should handle deletion failure', () async {
        final chatId = testUuid.toString();
        when(repository.deleteChat(chatId))
            .thenThrow(Exception('Deletion failed'));

        expect(
          () => repository.deleteChat(chatId),
          throwsException,
        );
        verify(repository.deleteChat(chatId)).called(1);
      });
    });
  });
}
