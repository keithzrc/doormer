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
    const testAudioDuration = Duration(seconds: 30);

    test('should create MessageModel instance with text type', () {
      final model = MessageModel(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: true,
        type: MessageType.text,
      );

      expect(model.id, testId);
      expect(model.content, testContent);
      expect(model.timestamp, testTimestamp);
      expect(model.isFromMe, true);
      expect(model.type, MessageType.text);
      expect(model.mediaUrl, isNull);
      expect(model.audioDuration, isNull);
    });

    test('should convert to and from entity', () {
      final model = MessageModel(
        id: testId,
        content: testContent,
        timestamp: testTimestamp,
        isFromMe: true,
        type: MessageType.text,
      );

      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.content, model.content);
      expect(entity.timestamp, model.timestamp);
      expect(entity.isFromMe, model.isFromMe);
      expect(entity.type, model.type);
    });

    group('JSON Serialization', () {
      test('should convert text message to JSON', () {
        final model = MessageModel(
          id: testId,
          content: testContent,
          timestamp: testTimestamp,
          isFromMe: true,
          type: MessageType.text,
        );

        final json = model.toJson();
        final fromJson = MessageModel.fromJson(json);

        expect(fromJson.id, model.id);
        expect(fromJson.content, model.content);
        expect(fromJson.timestamp, model.timestamp);
        expect(fromJson.type, model.type);
        expect(fromJson.isFromMe, model.isFromMe);
      });

      test('should convert media message to JSON', () {
        final model = MessageModel(
          id: testId,
          content: testContent,
          timestamp: testTimestamp,
          isFromMe: true,
          type: MessageType.image,
          mediaUrl: testMediaUrl,
        );

        final json = model.toJson();
        final fromJson = MessageModel.fromJson(json);

        expect(fromJson.mediaUrl, model.mediaUrl);
        expect(fromJson.type, MessageType.image);
      });

      test('should convert audio message to JSON', () {
        final model = MessageModel(
          id: testId,
          content: testContent,
          timestamp: testTimestamp,
          isFromMe: true,
          type: MessageType.audio,
          audioDuration: testAudioDuration,
        );

        final json = model.toJson();
        final fromJson = MessageModel.fromJson(json);

        expect(fromJson.audioDuration, model.audioDuration);
        expect(fromJson.type, MessageType.audio);
      });

      test('should handle invalid message type gracefully', () {
        final json = {
          'id': testId,
          'content': testContent,
          'timestamp': testTimestamp.toIso8601String(),
          'isFromMe': true,
          'type': 'invalid_type',
        };

        final model = MessageModel.fromJson(json);
        expect(model.type, MessageType.text); // 默认为文本类型
      });

      test('should handle missing optional fields', () {
        final json = {
          'id': testId,
          'content': testContent,
          'timestamp': testTimestamp.toIso8601String(),
          'isFromMe': true,
          'type': 'text',
        };

        final model = MessageModel.fromJson(json);
        expect(model.mediaUrl, isNull);
        expect(model.audioDuration, isNull);
      });
    });
  });
}