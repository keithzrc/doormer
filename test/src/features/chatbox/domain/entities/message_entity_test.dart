import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';

void main() {
  group('Message', () {
    const testId = 'msg123';
    const testContent = 'Hello, world!';
    final testTimestamp = DateTime(2024, 1, 1, 12, 0);
    const testIsFromMe = true;
    const testType = MessageType.text;
    const testMediaUrl = 'https://example.com/media.jpg';
    final testAudioDuration = const Duration(seconds: 30);

    test('should create Message instance with required fields', () {
      // Act
      final message = Message(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: testIsFromMe,
        type: testType,
      );

      // Assert
      expect(message, isA<Message>());
      expect(message.id, testId);
      expect(message.content, testContent);
      expect(message.timestamp, testTimestamp);
      expect(message.isFromMe, testIsFromMe);
      expect(message.type, testType);
      expect(message.mediaUrl, isNull);
      expect(message.audioDuration, isNull);
    });

    test('should create Message instance with all fields', () {
      // Act
      final message = Message(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: testIsFromMe,
        type: testType,
        mediaUrl: testMediaUrl,
        audioDuration: testAudioDuration,
      );

      // Assert
      expect(message.id, testId);
      expect(message.content, testContent);
      expect(message.timestamp, testTimestamp);
      expect(message.isFromMe, testIsFromMe);
      expect(message.type, testType);
      expect(message.mediaUrl, testMediaUrl);
      expect(message.audioDuration, testAudioDuration);
    });

    test('should implement value equality', () {
      // Arrange
      final message1 = Message(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: testIsFromMe,
        type: testType,
        mediaUrl: testMediaUrl,
        audioDuration: testAudioDuration,
      );

      final message2 = Message(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: testIsFromMe,
        type: testType,
        mediaUrl: testMediaUrl,
        audioDuration: testAudioDuration,
      );

      // Assert
      expect(message1, equals(message2));
      expect(message1.hashCode, equals(message2.hashCode));
    });

    test('should implement value inequality', () {
      // Arrange
      final message1 = Message(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: testIsFromMe,
        type: testType,
      );

      final message2 = Message(
        id: 'different_id',
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: testIsFromMe,
        type: testType,
      );

      // Assert
      expect(message1, isNot(equals(message2)));
    });

    test('copyWith should create new instance with updated values', () {
      // Arrange
      final original = Message(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: testIsFromMe,
        type: testType,
      );

      final newTimestamp = DateTime(2024, 1, 1, 13, 0);

      // Act
      final updated = original.copyWith(
        content: 'Updated content',
        timestamp: newTimestamp,
        type: MessageType.image,
        mediaUrl: testMediaUrl,
      );

      // Assert
      expect(updated.id, original.id);
      expect(updated.content, 'Updated content');
      expect(updated.timestamp, newTimestamp);
      expect(updated.isFromMe, original.isFromMe);
      expect(updated.type, MessageType.image);
      expect(updated.mediaUrl, testMediaUrl);
      expect(updated.audioDuration, isNull);
    });

    test('toString should contain all properties', () {
      // Arrange
      final message = Message(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: testIsFromMe,
        type: testType,
        mediaUrl: testMediaUrl,
        audioDuration: testAudioDuration,
      );

      // Act & Assert
      expect(
        message.toString(),
        'Message('
        'id: $testId, '
        'content: $testContent, '
        'timestamp: $testTimestamp, '
        'isFromMe: $testIsFromMe, '
        'type: $testType, '
        'mediaUrl: $testMediaUrl, '
        'audioDuration: $testAudioDuration)',
      );
    });

    group('MessageType', () {
      test('should have correct values', () {
        expect(MessageType.values.length, 6);
        expect(MessageType.text.name, 'text');
        expect(MessageType.image.name, 'image');
        expect(MessageType.file.name, 'file');
        expect(MessageType.voice.name, 'voice');
        expect(MessageType.emoji.name, 'emoji');
        expect(MessageType.audio.name, 'audio');
      });
    });
  });
} 