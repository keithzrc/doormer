import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late Contact testContact;

  setUp(() {
    testContact = Contact(
      id: UuidValue(const Uuid().v4()),
      userName: 'Test User',
      avatarUrl: 'https://example.com/avatar.png',
      lastMessage: 'Hello',
      lastMessageCreatedTime: DateTime.now(),
      isArchived: false,
      isRead: true,
    );
  });

  group('ChatState', () {
    test('ChatLoadingState should be instantiable', () {
      final state = ChatLoadingState();
      expect(state, isA<ChatState>());
    });

    test('ChatLoadedState should store chats', () {
      final chats = [testContact];
      final state = ChatLoadedState(chats);
      expect(state.chats, equals(chats));
    });

    test('ArchivedChatLoadedState should store chats', () {
      final chats = [testContact];
      final state = ArchivedChatLoadedState(chats);
      expect(state.archivedChats, equals(chats));
    });

    test('ChatErrorState should store error message', () {
      const error = 'test error';
      final state = ChatErrorState(error);
      expect(state.error, equals(error));
    });
  });
} 