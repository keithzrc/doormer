import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:doormer/src/features/chat/presentation/bloc/archive_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_state.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat.dart';
import 'package:doormer/src/features/chat/domain/usecases/delete_chat.dart';
import 'package:doormer/src/features/chat/domain/usecases/get_chat_list.dart';
import 'package:doormer/src/features/chat/domain/usecases/get_archived_list.dart';

// Mock dependencies
class MockGetChatList extends Mock implements GetChatList {}

class MockGetArchivedList extends Mock implements GetArchivedList {}

class MockArchiveChat extends Mock implements ArchiveChat {}

class MockDeleteChat extends Mock implements DeleteChat {}

void main() {
  late ChatBloc chatBloc;
  late MockGetChatList mockGetChatList;
  late MockGetArchivedList mockGetArchivedList;
  late MockArchiveChat mockArchiveChat;
  late MockDeleteChat mockDeleteChat;

  setUp(() {
    mockGetChatList = MockGetChatList();
    mockGetArchivedList = MockGetArchivedList();
    mockArchiveChat = MockArchiveChat();
    mockDeleteChat = MockDeleteChat();

    chatBloc = ChatBloc(
      getChatList: mockGetChatList,
      getArchivedChatList: mockGetArchivedList,
      archiveChat: mockArchiveChat,
      deleteChat: mockDeleteChat,
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc Tests', () {
    test('initial state is ChatLoadingState', () {
      expect(chatBloc.state, isA<ChatLoadingState>());
    });

    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoadingState, ChatLoadedState] when LoadChatsEvent is added and succeeds',
      setUp: () {
        when(() => mockGetChatList.call()).thenAnswer(
          (_) async => [
            Chat(
              id: '1',
              userName: 'John Doe',
              avatarUrl: 'https://example.com/avatar1.png',
              lastMessage: 'Hello there!',
              createdTime: DateTime(2023, 12, 10),
              isArchived: false,
            ),
          ],
        );
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>().having(
          (state) => state.chats,
          'chats',
          [
            isA<Chat>()
                .having((chat) => chat.id, 'id', '1')
                .having((chat) => chat.userName, 'userName', 'John Doe')
                .having(
                    (chat) => chat.lastMessage, 'lastMessage', 'Hello there!')
          ],
        ),
      ],
      verify: (_) {
        verify(() => mockGetChatList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoadingState, ChatErrorState] when LoadChatsEvent is added and fails',
      setUp: () {
        when(() => mockGetChatList.call())
            .thenThrow(Exception('Error fetching chats'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatErrorState>().having(
            (state) => state.error, 'error', 'Exception: Error fetching chats'),
      ],
      verify: (_) {
        verify(() => mockGetChatList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoadingState, ArchivedChatLoadedState] when LoadArchivedChatsEvent is added and succeeds',
      setUp: () {
        when(() => mockGetArchivedList.call()).thenAnswer(
          (_) async => [
            Chat(
              id: '2',
              userName: 'Jane Smith',
              avatarUrl: 'https://example.com/avatar2.png',
              lastMessage: 'Archived chat message',
              createdTime: DateTime(2023, 12, 10),
              isArchived: true,
            ),
          ],
        );
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ArchivedChatLoadedState>().having(
          (state) => state.archivedChats,
          'archivedChats',
          [
            isA<Chat>()
                .having((chat) => chat.id, 'id', '2')
                .having((chat) => chat.userName, 'userName', 'Jane Smith')
                .having((chat) => chat.lastMessage, 'lastMessage',
                    'Archived chat message')
          ],
        ),
      ],
      verify: (_) {
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'calls archiveChat and triggers LoadChatsEvent when ArchiveChatEvent is added',
      setUp: () {
        when(() => mockArchiveChat.call('1')).thenAnswer((_) async => {});
        when(() => mockGetChatList.call()).thenAnswer(
          (_) async => [
            Chat(
              id: '1',
              userName: 'John Doe',
              avatarUrl: 'https://example.com/avatar1.png',
              lastMessage: 'Hello there!',
              createdTime: DateTime(2023, 12, 10),
              isArchived: false,
            ),
          ],
        );
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(ArchiveChatEvent('1')),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>().having(
          (state) => state.chats,
          'chats',
          [
            isA<Chat>().having((chat) => chat.id, 'id', '1'),
          ],
        ),
      ],
      verify: (_) {
        verify(() => mockArchiveChat.call('1')).called(1);
        verify(() => mockGetChatList.call()).called(1);
      },
    );
    blocTest<ChatBloc, ChatState>(
      'calls deleteChat and triggers LoadArchivedChatsEvent when DeleteChatEvent is added',
      setUp: () {
        when(() => mockDeleteChat.call('1')).thenAnswer((_) async => {});
        when(() => mockGetArchivedList.call()).thenAnswer(
          (_) async => [
            Chat(
              id: '2',
              userName: 'Jane Smith',
              avatarUrl: 'https://example.com/avatar2.png',
              lastMessage: 'Archived chat message',
              createdTime: DateTime(2023, 12, 10),
              isArchived: true,
            ),
          ],
        );
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(DeleteChatEvent('1')),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ArchivedChatLoadedState>().having(
          (state) => state.archivedChats,
          'archivedChats',
          [
            isA<Chat>().having((chat) => chat.id, 'id', '2'),
          ],
        ),
      ],
      verify: (_) {
        verify(() => mockDeleteChat.call('1')).called(1);
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );
  });
}
