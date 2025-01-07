import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/data/models/message_model.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';

void main() {
  group('MessageModel', () {
    // Test data
    const testId = 'msg123';
    const testContent = 'Hello, world!';
    final testTimestamp = DateTime(2024, 1, 1, 12, 0);
    const testMediaUrl = 'https://example.com/media.jpg';
    final testAudioDuration = const Duration(seconds: 30);

    test('should create MessageModel instance with text type', () {
      // Arrange & Act
      final model = MessageModel(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: true,
        type: MessageType.text,
      );

      // Assert
      expect(model.id, testId);
      expect(model.content, testContent);
      expect(model.timestamp, testTimestamp);
      expect(model.isFromMe, true);
      expect(model.type, MessageType.text);
      expect(model.mediaUrl, null);
      expect(model.audioDuration, null);
    });

    test('should create MessageModel instance with image type and media URL', () {
      // Arrange & Act
      final model = MessageModel(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: false,
        type: MessageType.image,
        mediaUrl: testMediaUrl,
      );

      // Assert
      expect(model.id, testId);
      expect(model.content, testContent);
      expect(model.timestamp, testTimestamp);
      expect(model.isFromMe, false);
      expect(model.type, MessageType.image);
      expect(model.mediaUrl, testMediaUrl);
      expect(model.audioDuration, null);
    });

    test('should create MessageModel instance with audio type and duration', () {
      // Arrange & Act
      final model = MessageModel(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: true,
        type: MessageType.audio,
        mediaUrl: testMediaUrl,
        audioDuration: testAudioDuration,
      );

      // Assert
      expect(model.id, testId);
      expect(model.content, testContent);
      expect(model.timestamp, testTimestamp);
      expect(model.isFromMe, true);
      expect(model.type, MessageType.audio);
      expect(model.mediaUrl, testMediaUrl);
      expect(model.audioDuration, testAudioDuration);
    });

    test('should convert to JSON correctly', () {
      // Arrange
      final model = MessageModel(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: true,
        type: MessageType.audio,
        mediaUrl: testMediaUrl,
        audioDuration: testAudioDuration,
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json, {
        'id': testId,
        'content': testContent,
        'timestamp': testTimestamp.toIso8601String(),
        'isFromMe': true,
        'type': MessageType.audio.toString(),
        'mediaUrl': testMediaUrl,
        'audioDuration': testAudioDuration.inMilliseconds,
      });
    });

    test('should create instance from JSON correctly', () {
      // Arrange
      final json = {
        'id': testId,
        'content': testContent,
        'timestamp': testTimestamp.toIso8601String(),
        'isFromMe': true,
        'type': MessageType.audio.toString(),
        'mediaUrl': testMediaUrl,
        'audioDuration': testAudioDuration.inMilliseconds,
      };

      // Act
      final model = MessageModel.fromJson(json);

      // Assert
      expect(model.id, testId);
      expect(model.content, testContent);
      expect(model.timestamp, testTimestamp);
      expect(model.isFromMe, true);
      expect(model.type, MessageType.audio);
      expect(model.mediaUrl, testMediaUrl);
      expect(model.audioDuration, testAudioDuration);
    });

    test('should throw when required fields are missing in JSON', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act & Assert
      expect(
        () => MessageModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });
  });
} 