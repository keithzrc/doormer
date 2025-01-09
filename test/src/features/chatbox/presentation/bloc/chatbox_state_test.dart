import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_state.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';

void main() {
  group('ChatboxState', () {
    group('ChatboxInitial', () {
      test('supports value equality', () {
        expect(
          const ChatboxInitial(),
          equals(const ChatboxInitial()),
        );
      });

      test('props is empty', () {
        expect(const ChatboxInitial().props, isEmpty);
      });
    });

    group('MessagesLoading', () {
      test('supports value equality', () {
        expect(
          const MessagesLoading(),
          equals(const MessagesLoading()),
        );
      });

      test('props is empty', () {
        expect(const MessagesLoading().props, isEmpty);
      });
    });

    group('MessagesLoaded', () {
      final testMessages = [
        Message(
          id: 'test_message_id',
          content: 'test content',
          timestamp: DateTime(2024),
          isFromMe: true,
          type: MessageType.text,
        ),
      ];

      test('supports value equality', () {
        expect(
          MessagesLoaded(testMessages),
          equals(MessagesLoaded(testMessages)),
        );
      });

      test('props contains messages', () {
        expect(
          MessagesLoaded(testMessages).props,
          equals([testMessages]),
        );
      });
    });

    group('MessageSending', () {
      test('supports value equality', () {
        expect(
          const MessageSending(),
          equals(const MessageSending()),
        );
      });

      test('props is empty', () {
        expect(const MessageSending().props, isEmpty);
      });
    });

    group('MessageSent', () {
      test('supports value equality', () {
        expect(
          const MessageSent(),
          equals(const MessageSent()),
        );
      });

      test('props is empty', () {
        expect(const MessageSent().props, isEmpty);
      });
    });

    group('ContactInfoLoaded', () {
      final testContactInfo = ContactInfo(
        id: const UuidValueConverter()
            .fromJson('123e4567-e89b-12d3-a456-426614174000'),
        name: 'test',
        avatarUrl: 'test',
        position: 'test',
        expectedSalary: 'test',
        status: 'test',
      );

      test('supports value equality', () {
        expect(
          ContactInfoLoaded(testContactInfo),
          equals(ContactInfoLoaded(testContactInfo)),
        );
      });

      test('props contains contactInfo', () {
        expect(
          ContactInfoLoaded(testContactInfo).props,
          equals([testContactInfo]),
        );
      });
    });

    group('ChatboxError', () {
      const testError = 'test error';

      test('supports value equality', () {
        expect(
          const ChatboxError(testError),
          equals(const ChatboxError(testError)),
        );
      });

      test('props contains error', () {
        expect(
          const ChatboxError(testError).props,
          equals([testError]),
        );
      });
    });
  });
} 