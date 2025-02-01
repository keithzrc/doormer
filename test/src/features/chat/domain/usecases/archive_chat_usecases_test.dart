import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';

@GenerateNiceMocks([MockSpec<ContactRepository>()])
import 'archive_chat_usecases_test.mocks.dart';

void main() {
  late MockContactRepository mockRepository;
  late Contact testContact;
  late UuidValue testId;
  late UuidValue userId;
  final testDateTime = DateTime.parse('2024-01-01T12:00:00.000Z');

  setUp(() {
    mockRepository = MockContactRepository();
    testId = UuidValue(const Uuid().v4());
    userId = UuidValue(const Uuid().v4());
    testContact = Contact(
      id: testId,
      userName: 'Test User',
      avatarUrl: 'https://example.com/avatar.jpg',
      lastMessage: 'Hello World',
      lastMessageCreatedTime: testDateTime,
      isArchived: false,
      isRead: true,
    );
  });

  group('ToggleChatArchivedStatus', () {
    late ToggleChatArchivedStatus useCase;

    setUp(() {
      useCase = ToggleChatArchivedStatus(mockRepository);
    });

    test('should toggle chat archived status from false to true', () async {
      when(mockRepository.archiveChat(userId, testId, true))
          .thenAnswer((_) async {});

      final result = await useCase(userId, testContact);

      verify(mockRepository.archiveChat(userId, testId, true)).called(1);
      expect(result.isArchived, isTrue);
    });

    test('should toggle chat archived status from true to false', () async {
      final archivedContact = testContact.copyWith(isArchived: true);
      when(mockRepository.archiveChat(userId, testId, false))
          .thenAnswer((_) async {});

      final result = await useCase(userId, archivedContact);

      verify(mockRepository.archiveChat(userId, testId, false)).called(1);
      expect(result.isArchived, isFalse);
    });

    test('should handle repository errors', () async {
      when(mockRepository.archiveChat(userId, testId, true))
          .thenThrow(Exception('Archive failed'));

      expect(
        () => useCase(userId, testContact),
        throwsException,
      );
    });
  });

  group('GetSortedArchivedChatList', () {
    late GetSortedArchivedChatList useCase;

    setUp(() {
      useCase = GetSortedArchivedChatList(mockRepository);
    });

    test('should return sorted archived chats', () async {
      final olderContact = testContact.copyWith(
        lastMessageCreatedTime: testDateTime.subtract(const Duration(days: 1)),
        isArchived: true,
      );
      final newerContact = testContact.copyWith(
        lastMessageCreatedTime: testDateTime,
        isArchived: true,
      );

      when(mockRepository.getArchivedChatList(userId))
          .thenAnswer((_) async => [olderContact, newerContact]);

      final result = await useCase(userId);

      verify(mockRepository.getArchivedChatList(userId)).called(1);
      expect(result.length, 2);
      expect(result.first.lastMessageCreatedTime, equals(testDateTime));
      expect(result.last.lastMessageCreatedTime, equals(testDateTime.subtract(const Duration(days: 1))));
    });

    test('should handle repository errors', () async {
      when(mockRepository.getArchivedChatList(userId))
          .thenThrow(Exception('Fetch failed'));

      expect(
        () => useCase(userId),
        throwsException,
      );
    });
  });

  group('GetSortedActiveChatList', () {
    late GetSortedActiveChatList useCase;

    setUp(() {
      useCase = GetSortedActiveChatList(mockRepository);
    });

    test('should return sorted active chats', () async {
      final olderContact = testContact.copyWith(
        lastMessageCreatedTime: testDateTime.subtract(const Duration(days: 1)),
      );
      final newerContact = testContact.copyWith(
        lastMessageCreatedTime: testDateTime,
      );

      when(mockRepository.getActiveChatList(userId))
          .thenAnswer((_) async => [olderContact, newerContact]);

      final result = await useCase(userId);

      verify(mockRepository.getActiveChatList(userId)).called(1);
      expect(result.length, 2);
      expect(result.first.lastMessageCreatedTime, equals(testDateTime));
      expect(result.last.lastMessageCreatedTime, equals(testDateTime.subtract(const Duration(days: 1))));
    });

    test('should handle repository errors', () async {
      when(mockRepository.getActiveChatList(userId))
          .thenThrow(Exception('Fetch failed'));

      expect(
        () => useCase(userId),
        throwsException,
      );
    });
  });
}


