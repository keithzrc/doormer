import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat.dart';

// Mock dependencies
class MockGetChatList extends Mock implements GetUnarchivedchatList {}

class MockGetArchivedList extends Mock implements GetArchivedList {}

class MockArchiveChat extends Mock implements ToggleChat {}

class MockUnarchiveChat extends Mock implements UnarchiveChat {}

class MockDeleteChat extends Mock implements DeleteChat {}

void main() {
  late ChatArchiveBloc chatBloc;
  late MockGetChatList mockGetChatList;
  late MockGetArchivedList mockGetArchivedList;
  late MockArchiveChat mockArchiveChat;
  late MockUnarchiveChat mockUnarchiveChat;
  late MockDeleteChat mockDeleteChat;

  setUp(() {
    mockGetChatList = MockGetChatList();
    mockGetArchivedList = MockGetArchivedList();
    mockArchiveChat = MockArchiveChat();
    mockUnarchiveChat = MockUnarchiveChat();
    mockDeleteChat = MockDeleteChat();

    chatBloc = ChatArchiveBloc(
      getChatListUseCase: mockGetChatList,
      getArchivedChatListUseCase: mockGetArchivedList,
      archiveChatUseCase: mockArchiveChat,
      unarchiveChatUseCase: mockUnarchiveChat,
      deleteChatUseCase: mockDeleteChat,
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc Tests', () {
    test('initial state should be ChatLoadingState if no chats are preloaded',
        () {
      final chatBloc = ChatArchiveBloc(
        getChatListUseCase: mockGetChatList,
        getArchivedChatListUseCase: mockGetArchivedList,
        archiveChatUseCase: mockArchiveChat,
        unarchiveChatUseCase: mockUnarchiveChat,
        deleteChatUseCase: mockDeleteChat,
        initialChats: null,
      );
      expect(chatBloc.state, isA<ChatLoadingState>());
    });
    test('initial state should be ChatLoadedState if chats are preloaded', () {
      final chatBloc = ChatArchiveBloc(
        getChatListUseCase: mockGetChatList,
        getArchivedChatListUseCase: mockGetArchivedList,
        archiveChatUseCase: mockArchiveChat,
        unarchiveChatUseCase: mockUnarchiveChat,
        deleteChatUseCase: mockDeleteChat,
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

    blocTest<ChatArchiveBloc, ChatState>(
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

    blocTest<ChatArchiveBloc, ChatState>(
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

    blocTest<ChatArchiveBloc, ChatState>(
      'should emit [ArchivedChatLoadingState, ArchivedChatLoadedState] when LoadArchivedChatsEvent is successfully handled',
      setUp: () {
        when(() => mockGetArchivedList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        isA<ArchivedChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );
    blocTest<ChatArchiveBloc, ChatState>(
      'should emit [ArchivedChatLoadingState, ChatErrorState] when LoadArchivedChatsEvent fails to fetch the archived chat list data',
      setUp: () {
        when(() => mockGetArchivedList.call())
            .thenThrow(Exception('Error fetching archived chats'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        isA<ChatErrorState>(),
      ],
      verify: (_) {
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );
    blocTest<ChatArchiveBloc, ChatState>(
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
    blocTest<ChatArchiveBloc, ChatState>(
      'should call unArchiveChat and then emit [ArchivedChatLoadingState, ArchivedChatLoadedState] to refresh the archived chat list after UnArchiveChatEvent is handled',
      setUp: () {
        when(() => mockUnarchiveChat.call('1')).thenAnswer((_) async => {});
        when(() => mockGetArchivedList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(UnArchiveChatEvent('1')),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        isA<ArchivedChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockUnarchiveChat.call('1')).called(1);
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );

    blocTest<ChatArchiveBloc, ChatState>(
      'should call deleteChat and then emit [ArchivedChatLoadingState, ArchivedChatLoadedState] to refresh the archived chat list after DeleteChatEvent is handled',
      setUp: () {
        when(() => mockDeleteChat.call('1')).thenAnswer((_) async => {});
        when(() => mockGetArchivedList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(DeleteChatEvent('1')),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        isA<ArchivedChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockDeleteChat.call('1')).called(1);
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );
  });
}
