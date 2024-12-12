import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:doormer/src/features/chat/presentation/bloc/archive_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_state.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat.dart';

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
    test('initial state should be ChatLoadingState if no chats are preloaded',
        () {
      final chatBloc = ChatBloc(
        getChatList: mockGetChatList,
        getArchivedChatList: mockGetArchivedList,
        archiveChat: mockArchiveChat,
        deleteChat: mockDeleteChat,
        initialChats: null,
      );
      expect(chatBloc.state, isA<ChatLoadingState>());
    });
    test('initial state should be ChatLoadedState if chats are preloaded', () {
      final chatBloc = ChatBloc(
        getChatList: mockGetChatList,
        getArchivedChatList: mockGetArchivedList,
        archiveChat: mockArchiveChat,
        deleteChat: mockDeleteChat,
        initialChats: [
          Chat(
              id: '1',
              userName: 'John Doe',
              avatarUrl: '',
              lastMessage: '',
              createdTime: DateTime.now(),
              isArchived: false),
        ],
      );
      expect(chatBloc.state, isA<ChatLoadedState>());
      expect((chatBloc.state as ChatLoadedState).chats.length, 1);
    });

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoadingState, ChatLoadedState] when LoadChatsEvent is successfully handled',
      setUp: () {
        when(() => mockGetChatList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockGetChatList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoadingState, ChatErrorState] when LoadChatsEvent fails to fetch the chat list data',
      setUp: () {
        when(() => mockGetChatList.call())
            .thenThrow(Exception('Error fetching chats'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatErrorState>(),
      ],
      verify: (_) {
        verify(() => mockGetChatList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoadingState, ArchivedChatLoadedState] when LoadArchivedChatsEvent is successfully handled',
      setUp: () {
        when(() => mockGetArchivedList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ArchivedChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoadingState, ChatErrorState] when LoadArchivedChatsEvent fails to fetch the archived chat list data',
      setUp: () {
        when(() => mockGetArchivedList.call())
            .thenThrow(Exception('Error fetching archived chats'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatErrorState>(),
      ],
      verify: (_) {
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );
    blocTest<ChatBloc, ChatState>(
      'should call archiveChat and then emit [ChatLoadingState, ChatLoadedState] to refresh the chat list after ArchiveChatEvent is handled',
      setUp: () {
        when(() => mockArchiveChat.call('1')).thenAnswer((_) async => {});
        when(() => mockGetChatList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(ArchiveChatEvent('1')),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockArchiveChat.call('1')).called(1);
        verify(() => mockGetChatList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should call deleteChat and then emit [ChatLoadingState, ArchivedChatLoadedState] to refresh the archived chat list after DeleteChatEvent is handled',
      setUp: () {
        when(() => mockDeleteChat.call('1')).thenAnswer((_) async => {});
        when(() => mockGetArchivedList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(DeleteChatEvent('1')),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ArchivedChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockDeleteChat.call('1')).called(1);
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );
  });
}
