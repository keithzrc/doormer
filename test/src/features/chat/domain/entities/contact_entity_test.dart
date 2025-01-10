import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Contact', () {
    final testUuid = UuidValue(const Uuid().v4());
    final testDateTime = DateTime.parse('2024-01-01T12:00:00.000Z');

    test('should create Contact instance with valid parameters', () {
      final contact = Contact(
        id: testUuid,
        userName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        lastMessage: 'Hello World',
        lastMessageCreatedTime: testDateTime,
        isArchived: false,
        isRead: true,
      );

      expect(contact.id, equals(testUuid));
      expect(contact.userName, equals('Test User'));
      expect(contact.avatarUrl, equals('https://example.com/avatar.jpg'));
      expect(contact.lastMessage, equals('Hello World'));
      expect(contact.lastMessageCreatedTime, equals(testDateTime));
      expect(contact.isArchived, isFalse);
      expect(contact.isRead, isTrue);
    });

    test('should compare equal for identical properties', () {
      final contact1 = Contact(
        id: testUuid,
        userName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        lastMessage: 'Hello World',
        lastMessageCreatedTime: testDateTime,
        isArchived: false,
        isRead: true,
      );

      final contact2 = Contact(
        id: testUuid,
        userName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        lastMessage: 'Hello World',
        lastMessageCreatedTime: testDateTime,
        isArchived: false,
        isRead: true,
      );

      expect(contact1, equals(contact2));
      expect(contact1.hashCode, equals(contact2.hashCode));
    });

    test('should not be equal with different properties', () {
      final contact1 = Contact(
        id: testUuid,
        userName: 'Test User 1',
        avatarUrl: 'https://example.com/avatar1.jpg',
        lastMessage: 'Hello',
        lastMessageCreatedTime: testDateTime,
        isArchived: false,
        isRead: true,
      );

      final contact2 = Contact(
        id: testUuid,
        userName: 'Test User 2',
        avatarUrl: 'https://example.com/avatar2.jpg',
        lastMessage: 'Hi',
        lastMessageCreatedTime: testDateTime,
        isArchived: true,
        isRead: false,
      );

      expect(contact1, isNot(equals(contact2)));
      expect(contact1.hashCode, isNot(equals(contact2.hashCode)));
    });

    test('should copy with new values', () {
      final original = Contact(
        id: testUuid,
        userName: 'Test User',
        avatarUrl: 'https://example.com/avatar.jpg',
        lastMessage: 'Hello',
        lastMessageCreatedTime: testDateTime,
        isArchived: false,
        isRead: true,
      );

      final updated = original.copyWith(
        userName: 'Updated User',
        lastMessage: 'Updated Message',
        isArchived: true,
      );

      expect(updated.id, equals(original.id));
      expect(updated.userName, equals('Updated User'));
      expect(updated.avatarUrl, equals(original.avatarUrl));
      expect(updated.lastMessage, equals('Updated Message'));
      expect(updated.lastMessageCreatedTime, equals(original.lastMessageCreatedTime));
      expect(updated.isArchived, isTrue);
      expect(updated.isRead, equals(original.isRead));
    });
  });
}
