import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:doormer/src/features/chatbox/data/repositories/chatbox_repository_impl.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';
import 'package:uuid/uuid.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  group('ChatboxRepositoryImpl', () {
    late ChatboxRepositoryImpl repository;
    late MockLocalDataSource mockLocalDataSource;
    late List<ContactModel> testContacts;
    late DateTime testTime;
    late UuidValue testUuid;

    setUp(() {
      mockLocalDataSource = MockLocalDataSource();
      testTime = DateTime(2024, 1, 1, 12, 0);
      testUuid = const UuidValueConverter()
          .fromJson('123e4567-e89b-12d3-a456-426614174000');

      testContacts = [
        ContactModel(
          id: testUuid,
          userName: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
          lastMessage: 'Hello',
          lastMessageCreatedTime: testTime,
          isArchived: false,
          isRead: true,
        ),
      ];

      when(() => mockLocalDataSource.loadDummyData())
          .thenAnswer((_) async => testContacts);

      repository = ChatboxRepositoryImpl(localDataSource: mockLocalDataSource);
    });

    test('getContactInfo should return contact info', () async {
      final contactId = testUuid.toString();
      final result = await repository.getContactInfo(contactId);

      expect(result, isA<ContactInfo>());
      expect(result.id, equals(contactId));
      expect(result.name, equals('Test User'));
      expect(result.avatarUrl, equals('https://example.com/avatar.jpg'));
      expect(result.status, equals('Active'));
    });

    test('getMessages should emit messages', () async {
      final contactId = testUuid.toString();
      final stream = repository.getMessages(contactId);

      await expectLater(
        stream,
        emits(isA<List<Message>>()),
      );
    });

    test('sendMessage should complete without error', () async {
      final message = Message(
        id: testUuid.toString(),
        content: 'Test message',
        timestamp: testTime,
        isFromMe: true,
        type: MessageType.text,
      );

      await expectLater(repository.sendMessage(message), completes);
    });

    test('sendFile should complete without error', () async {
      await expectLater(
        repository.sendFile('test/image.jpg', MessageType.image),
        completes,
      );
    });

    test('deleteMessage should complete without error', () async {
      final messageId = testUuid.toString();
      await expectLater(repository.deleteMessage(messageId), completes);
    });

    test('updateMessage should complete without error', () async {
      final message = Message(
        id: testUuid.toString(),
        content: 'Updated content',
        timestamp: testTime,
        isFromMe: true,
        type: MessageType.text,
      );

      await expectLater(repository.updateMessage(message), completes);
    });

    test('dispose should close message controller without error', () {
      expect(() => repository.dispose(), returnsNormally);
    });

    test('getContactInfo should throw when contact not found', () async {
      final nonExistentId = const UuidValueConverter()
          .fromJson('123e4567-e89b-12d3-a456-426614174999')
          .toString();

      await expectLater(
        () => repository.getContactInfo(nonExistentId),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          'Exception: Contact not found',
        )),
      );
    });
  });
}
