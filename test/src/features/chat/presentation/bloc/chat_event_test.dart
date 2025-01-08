import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('ChatEvent', () {
    late String testId;

    setUp(() {
      testId = const Uuid().v4();
    });

    test('LoadChatsEvent should be instantiable', () {
      final event = LoadChatsEvent();
      expect(event, isA<ChatEvent>());
    });

    test('LoadArchivedChatsEvent should be instantiable', () {
      final event = LoadArchivedChatsEvent();
      expect(event, isA<ChatEvent>());
    });

    test('ToggleChatEvent should store chatId', () {
      final event = ToggleChatEvent(testId);
      expect(event.chatId, equals(testId));
    });

    test('DeleteChatEvent should store chatId', () {
      final event = DeleteChatEvent(testId);
      expect(event.chatId, equals(testId));
    });
  });
}