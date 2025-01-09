import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/repositories/chatbox_repository.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';

class MockChatboxRepository extends Mock implements ChatboxRepository {}

void main() {
  group('ChatboxRepository', () {
    late ChatboxRepository repository;
    late UuidValue testContactId;
    late UuidValue testMessageId;
    late DateTime testTime;

    setUp(() {
      repository = MockChatboxRepository();
      testContactId = const UuidValueConverter()
          .fromJson('123e4567-e89b-12d3-a456-426614174000');
      testMessageId = const UuidValueConverter()
          .fromJson('123e4567-e89b-12d3-a456-426614174001');
      testTime = DateTime(2024);
    });

    group('getMessages', () {
      test('should return stream of messages', () {
        // Arrange
        final messages = [
          Message(
            id: testMessageId.toString(),
            content: 'Test message',
            timestamp: testTime,
            isFromMe: true,
            type: MessageType.text,
          ),
        ];

        when(() => repository.getMessages(testContactId.toString()))
            .thenAnswer((_) => Stream.value(messages));

        // Act
        final stream = repository.getMessages(testContactId.toString());

        // Assert
        expect(stream, emits(messages));
      });
    });

    group('sendMessage', () {
      test('should send message successfully', () async {
        // Arrange
        final message = Message(
          id: testMessageId.toString(),
          content: 'Test message',
          timestamp: testTime,
          isFromMe: true,
          type: MessageType.text,
        );

        when(() => repository.sendMessage(message))
            .thenAnswer((_) => Future.value());

        // Act & Assert
        expect(repository.sendMessage(message), completes);
      });
    });

    group('sendFile', () {
      test('should send file successfully', () async {
        // Arrange
        const path = 'test/path/file.jpg';
        const type = MessageType.image;

        when(() => repository.sendFile(path, type))
            .thenAnswer((_) => Future.value());

        // Act & Assert
        expect(repository.sendFile(path, type), completes);
      });
    });

    group('getContactInfo', () {
      test('should return contact info', () async {
        // Arrange
        final contactInfo = ContactInfo(
          id: testContactId,
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
          position: 'Developer',
          expectedSalary: '100k',
          status: 'Active',
        );

        when(() => repository.getContactInfo(testContactId.toString()))
            .thenAnswer((_) => Future.value(contactInfo));

        // Act
        final result = await repository.getContactInfo(testContactId.toString());

        // Assert
        expect(result, equals(contactInfo));
      });
    });

    group('deleteMessage', () {
      test('should delete message successfully', () async {
        // Arrange
        when(() => repository.deleteMessage(testMessageId.toString()))
            .thenAnswer((_) => Future.value());

        // Act & Assert
        expect(repository.deleteMessage(testMessageId.toString()), completes);
      });
    });

    group('updateMessage', () {
      test('should update message successfully', () async {
        // Arrange
        final message = Message(
          id: testMessageId.toString(),
          content: 'Updated message',
          timestamp: testTime,
          isFromMe: true,
          type: MessageType.text,
        );

        when(() => repository.updateMessage(message))
            .thenAnswer((_) => Future.value());

        // Act & Assert
        expect(repository.updateMessage(message), completes);
      });
    });
  });
} 