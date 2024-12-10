import 'package:test/test.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';

void main() {
  group('Chat class tests', () {
    test('should create a Chat object with all fields correctly assigned', () {
      final chat = Chat(
        id: '1',
        userName: 'John Doe',
        avatarUrl: 'https://example.com/avatar.png',
        lastMessage: 'Hello!',
        createdTime: DateTime(2024, 12, 10, 10, 0, 0),
        isArchived: false,
      );

      expect(chat.id, '1');
      expect(chat.userName, 'John Doe');
      expect(chat.avatarUrl, 'https://example.com/avatar.png');
      expect(chat.lastMessage, 'Hello!');
      expect(chat.createdTime, DateTime(2024, 12, 10, 10, 0, 0));
      expect(chat.isArchived, isFalse);
    });

    test('should handle null createdTime correctly', () {
      final chat = Chat(
        id: '2',
        userName: 'Jane Smith',
        avatarUrl: 'https://example.com/avatar2.png',
        lastMessage: 'Hi!',
        createdTime: null,
        isArchived: true,
      );

      expect(chat.id, '2');
      expect(chat.userName, 'Jane Smith');
      expect(chat.avatarUrl, 'https://example.com/avatar2.png');
      expect(chat.lastMessage, 'Hi!');
      expect(chat.createdTime, isNull);
      expect(chat.isArchived, isTrue);
    });

    test('should compare two Chat objects with the same data as equal', () {
      final chat1 = Chat(
        id: '3',
        userName: 'Alice',
        avatarUrl: 'https://example.com/avatar3.png',
        lastMessage: 'What\'s up?',
        createdTime: DateTime(2024, 12, 10, 12, 0, 0),
        isArchived: false,
      );

      final chat2 = Chat(
        id: '3',
        userName: 'Alice',
        avatarUrl: 'https://example.com/avatar3.png',
        lastMessage: 'What\'s up?',
        createdTime: DateTime(2024, 12, 10, 12, 0, 0),
        isArchived: false,
      );

      expect(chat1.id, chat2.id);
      expect(chat1.userName, chat2.userName);
      expect(chat1.avatarUrl, chat2.avatarUrl);
      expect(chat1.lastMessage, chat2.lastMessage);
      expect(chat1.createdTime, chat2.createdTime);
      expect(chat1.isArchived, chat2.isArchived);
    });
  });
}
