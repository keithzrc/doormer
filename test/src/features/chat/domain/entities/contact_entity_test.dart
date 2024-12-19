import 'package:test/test.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';

void main() {
  group('Contact class tests', () {
    test('should create a Contact object with all fields correctly assigned', () {
      final contact = Contact(
        id: '1',
        userName: 'John Doe',
        avatarUrl: 'https://example.com/avatar.png',
        lastMessage: 'Hello!',
        createdTime: DateTime(2024, 12, 10, 10, 0, 0),
        isArchived: false,
        isRead: true,
      );

      expect(contact.id, '1');
      expect(contact.userName, 'John Doe');
      expect(contact.avatarUrl, 'https://example.com/avatar.png');
      expect(contact.lastMessage, 'Hello!');
      expect(contact.createdTime, DateTime(2024, 12, 10, 10, 0, 0));
      expect(contact.isArchived, isFalse);
      expect(contact.isRead, isTrue);
    });

    test('should handle null createdTime correctly', () {
      final contact = Contact(
        id: '2',
        userName: 'Jane Smith',
        avatarUrl: 'https://example.com/avatar2.png',
        lastMessage: 'Hi!',
        createdTime: null,
        isArchived: true,
        isRead: false,
      );

      expect(contact.id, '2');
      expect(contact.userName, 'Jane Smith');
      expect(contact.avatarUrl, 'https://example.com/avatar2.png');
      expect(contact.lastMessage, 'Hi!');
      expect(contact.createdTime, isNull);
      expect(contact.isArchived, isTrue);
      expect(contact.isRead, isFalse);
    });

    test('copyWith should create a new Contact with specified fields updated', () {
      final originalContact = Contact(
        id: '3',
        userName: 'Alice',
        avatarUrl: 'https://example.com/avatar3.png',
        lastMessage: 'What\'s up?',
        createdTime: DateTime(2024, 12, 10, 12, 0, 0),
        isArchived: false,
        isRead: true,
      );

      final updatedContact = originalContact.copyWith(
        userName: 'Alice Updated',
        lastMessage: 'New message',
        isArchived: true,
      );

      // 验证更新的字段
      expect(updatedContact.userName, 'Alice Updated');
      expect(updatedContact.lastMessage, 'New message');
      expect(updatedContact.isArchived, isTrue);

      // 验证未更新的字段保持不变
      expect(updatedContact.id, originalContact.id);
      expect(updatedContact.avatarUrl, originalContact.avatarUrl);
      expect(updatedContact.createdTime, originalContact.createdTime);
      expect(updatedContact.isRead, originalContact.isRead);
    });

    test('copyWith should handle all null parameters', () {
      final originalContact = Contact(
        id: '4',
        userName: 'Bob',
        avatarUrl: 'https://example.com/avatar4.png',
        lastMessage: 'Original message',
        createdTime: DateTime(2024, 12, 10, 14, 0, 0),
        isArchived: false,
        isRead: true,
      );

      final copiedContact = originalContact.copyWith();

      expect(copiedContact.id, originalContact.id);
      expect(copiedContact.userName, originalContact.userName);
      expect(copiedContact.avatarUrl, originalContact.avatarUrl);
      expect(copiedContact.lastMessage, originalContact.lastMessage);
      expect(copiedContact.createdTime, originalContact.createdTime);
      expect(copiedContact.isArchived, originalContact.isArchived);
      expect(copiedContact.isRead, originalContact.isRead);
    });
  });
}
