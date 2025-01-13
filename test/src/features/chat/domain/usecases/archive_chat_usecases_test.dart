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
  final testUuid = UuidValue(const Uuid().v4());
  final testDateTime = DateTime.parse('2024-01-01T12:00:00.000Z');

  setUp(() {
    mockRepository = MockContactRepository();
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

  group('ToggleChatArchivedStatus', () {
    late ToggleChatArchivedStatus useCase;

    setUp(() {
      useCase = ToggleChatArchivedStatus(mockRepository);
    });

    test('should toggle chat archived status from false to true', () async {
      when(mockRepository.updateChat(any)).thenAnswer((_) async {});

      final result = await useCase(testContact);

      verify(mockRepository.updateChat(result)).called(1);
      expect(result.isArchived, isTrue);
    });

    test('should toggle chat archived status from true to false', () async {
      final archivedContact = testContact.copyWith(isArchived: true);
      when(mockRepository.updateChat(any)).thenAnswer((_) async {});

      final result = await useCase(archivedContact);

      verify(mockRepository.updateChat(result)).called(1);
      expect(result.isArchived, isFalse);
    });

    test('should handle repository errors', () async {
      when(mockRepository.updateChat(any))
          .thenThrow(Exception('Update failed'));

      expect(
        () => useCase(testContact),
        throwsException,
      );
    });
  });

  group('DeleteChat', () {
    late DeleteChat useCase;

    setUp(() {
      useCase = DeleteChat(mockRepository);
    });

    test('should delete chat successfully', () async {
      final chatId = testUuid.toString();
      when(mockRepository.deleteChat(chatId)).thenAnswer((_) async {});

      await useCase(chatId);

      verify(mockRepository.deleteChat(chatId)).called(1);
    });

    test('should handle repository errors', () async {
      final chatId = testUuid.toString();
      when(mockRepository.deleteChat(chatId))
          .thenThrow(Exception('Deletion failed'));

      expect(
        () => useCase(chatId),
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

      when(mockRepository.getArchivedChatList())
          .thenAnswer((_) async => [olderContact, newerContact]);

      final result = await useCase();

      verify(mockRepository.getArchivedChatList()).called(1);
      expect(result.length, equals(2));
      expect(result.first, equals(newerContact));
      expect(result.last, equals(olderContact));
    });

    test('should handle empty list', () async {
      when(mockRepository.getArchivedChatList())
          .thenAnswer((_) async => []);

      final result = await useCase();

      verify(mockRepository.getArchivedChatList()).called(1);
      expect(result, isEmpty);
    });

    test('should throw exception when repository fails', () {
      when(mockRepository.getArchivedChatList())
          .thenThrow(Exception('Failed to get archived chats'));

      expect(
        () => useCase(),
        throwsException
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

      when(mockRepository.getActiveChatList())
          .thenAnswer((_) async => [olderContact, newerContact]);

      final result = await useCase();

      verify(mockRepository.getActiveChatList()).called(1);
      expect(result.length, equals(2));
      expect(result.first, equals(newerContact));
      expect(result.last, equals(olderContact));
    });

    test('should handle empty list', () async {
      when(mockRepository.getActiveChatList())
          .thenAnswer((_) async => []);

      final result = await useCase();

      expect(result, isEmpty);
      verify(mockRepository.getActiveChatList()).called(1);
    });

    test('should throw exception when repository fails', () {
      when(mockRepository.getActiveChatList())
          .thenThrow(Exception('Failed to get active chats'));

      expect(
        () => useCase(),
        throwsException
      );
    });
  });
}