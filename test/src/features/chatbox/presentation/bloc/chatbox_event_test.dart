import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_event.dart';

void main() {
  group('ChatboxEvent', () {
    group('LoadMessages', () {
      test('supports value equality', () {
        expect(
          const LoadMessages('test_id'),
          equals(const LoadMessages('test_id')),
        );
      });

      test('props contains contactId', () {
        expect(
          const LoadMessages('test_id').contactId,
          'test_id',
        );
      });
    });

    group('SendMessageEvent', () {
      final testMessage = Message(
        id: 'test_id',
        content: 'test content',
        timestamp: DateTime(2024),
        isFromMe: true,
        type: MessageType.text,
      );

      test('supports value equality', () {
        expect(
          SendMessageEvent(testMessage),
          equals(SendMessageEvent(testMessage)),
        );
      });

      test('props contains message', () {
        expect(
          SendMessageEvent(testMessage).message,
          testMessage,
        );
      });
    });

    group('SendFileEvent', () {
      const testPath = 'test/path/file.jpg';
      const testType = MessageType.image;

      test('supports value equality', () {
        expect(
          const SendFileEvent(testPath, testType),
          equals(const SendFileEvent(testPath, testType)),
        );
      });

      test('props contains path and type', () {
        const event = SendFileEvent(testPath, testType);
        expect(event.path, testPath);
        expect(event.type, testType);
      });
    });

    group('LoadContactInfo', () {
      test('supports value equality', () {
        expect(
          const LoadContactInfo('test_id'),
          equals(const LoadContactInfo('test_id')),
        );
      });

      test('props contains contactId', () {
        expect(
          const LoadContactInfo('test_id').contactId,
          'test_id',
        );
      });
    });

    group('DeleteMessageEvent', () {
      test('supports value equality', () {
        expect(
          const DeleteMessageEvent('test_id'),
          equals(const DeleteMessageEvent('test_id')),
        );
      });

      test('props contains messageId', () {
        expect(
          const DeleteMessageEvent('test_id').messageId,
          'test_id',
        );
      });
    });

    group('UpdateMessageEvent', () {
      final testMessage = Message(
        id: 'test_id',
        content: 'test content',
        timestamp: DateTime(2024),
        isFromMe: true,
        type: MessageType.text,
      );

      test('supports value equality', () {
        expect(
          UpdateMessageEvent(testMessage),
          equals(UpdateMessageEvent(testMessage)),
        );
      });

      test('props contains message', () {
        expect(
          UpdateMessageEvent(testMessage).message,
          testMessage,
        );
      });
    });
  });
} 