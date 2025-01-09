import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chatbox/domain/repositories/chatbox_repository.dart';
import 'package:doormer/src/features/chatbox/domain/usecase/chatbox_usecase.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';
import 'package:uuid/uuid.dart';

class MockChatboxRepository extends Mock implements ChatboxRepository {}

void main() {
  late ChatboxRepository mockRepository;
  late GetMessages getMessages;
  late SendMessage sendMessage;
  late SendFile sendFile;
  late GetContactInfo getContactInfo;
  late UuidValue testContactId;
  late UuidValue testMessageId;
  late DateTime testTime;

  setUp(() {
    mockRepository = MockChatboxRepository();
    getMessages = GetMessages(mockRepository);
    sendMessage = SendMessage(mockRepository);
    sendFile = SendFile(mockRepository);
    getContactInfo = GetContactInfo(mockRepository);
    testContactId = const UuidValueConverter()
        .fromJson('123e4567-e89b-12d3-a456-426614174000');
    testMessageId = const UuidValueConverter()
        .fromJson('123e4567-e89b-12d3-a456-426614174001');
    testTime = DateTime(2024);
  });

  group('GetMessages', () {
    test('should get messages from repository', () {
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

      when(() => mockRepository.getMessages(testContactId.toString()))
          .thenAnswer((_) => Stream.value(messages));

      // Act
      final result = getMessages(testContactId.toString());

      // Assert
      expect(result, emits(messages));
      verify(() => mockRepository.getMessages(testContactId.toString())).called(1);
    });
  });

  group('SendMessage', () {
    test('should send message through repository', () async {
      // Arrange
      final message = Message(
        id: testMessageId.toString(),
        content: 'Test message',
        timestamp: testTime,
        isFromMe: true,
        type: MessageType.text,
      );

      when(() => mockRepository.sendMessage(message))
          .thenAnswer((_) => Future.value());

      // Act
      await sendMessage(message);

      // Assert
      verify(() => mockRepository.sendMessage(message)).called(1);
    });
  });

  group('SendFile', () {
    test('should send file through repository', () async {
      // Arrange
      const path = 'test/path/file.jpg';
      const type = MessageType.image;

      when(() => mockRepository.sendFile(path, type))
          .thenAnswer((_) => Future.value());

      // Act
      await sendFile(path, type);

      // Assert
      verify(() => mockRepository.sendFile(path, type)).called(1);
    });
  });

  group('GetContactInfo', () {
    test('should get contact info from repository', () async {
      // Arrange
      final contactInfo = ContactInfo(
        id: testContactId,
        name: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        position: 'Developer',
        expectedSalary: '100k',
        status: 'Active',
      );

      when(() => mockRepository.getContactInfo(testContactId.toString()))
          .thenAnswer((_) => Future.value(contactInfo));

      // Act
      final result = await getContactInfo(testContactId.toString());

      // Assert
      expect(result, equals(contactInfo));
      verify(() => mockRepository.getContactInfo(testContactId.toString()))
          .called(1);
    });

    test('should throw when repository throws', () async {
      // Arrange
      when(() => mockRepository.getContactInfo(testContactId.toString()))
          .thenThrow(Exception('Failed to get contact info'));

      // Act & Assert
      expect(
        () => getContactInfo(testContactId.toString()),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Error Handling', () {
    test('SendMessage should propagate errors', () {
      // Arrange
      final message = Message(
        id: testMessageId.toString(),
        content: 'Test message',
        timestamp: testTime,
        isFromMe: true,
        type: MessageType.text,
      );

      when(() => mockRepository.sendMessage(message))
          .thenThrow(Exception('Failed to send message'));

      // Act & Assert
      expect(
        () => sendMessage(message),
        throwsA(isA<Exception>()),
      );
    });

    test('SendFile should propagate errors', () {
      // Arrange
      const path = 'test/path/file.jpg';
      const type = MessageType.image;

      when(() => mockRepository.sendFile(path, type))
          .thenThrow(Exception('Failed to send file'));

      // Act & Assert
      expect(
        () => sendFile(path, type),
        throwsA(isA<Exception>()),
      );
    });
  });
} 