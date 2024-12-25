import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';

// Mock dependencies
class MockGetActiveChatList extends Mock implements GetSortedActiveChatList {}

class MockGetArchivedChatList extends Mock
    implements GetSortedArchivedChatList {}

class MockToggleChatArchivedStatus extends Mock
    implements ToggleChatArchivedStatus {}

class MockDeleteChat extends Mock implements DeleteChat {}

class FakeContact extends Fake implements Contact {}

void main() {
  late ChatBloc chatBloc;
  late MockGetActiveChatList mockGetActiveChatList;
  late MockGetArchivedChatList mockGetArchivedChatList;
  late MockToggleChatArchivedStatus mockToggleChatArchivedStatus;
  late MockDeleteChat mockDeleteChat;
  setUpAll(() {
    registerFallbackValue(FakeContact());
  });

  setUp(() {
    mockGetActiveChatList = MockGetActiveChatList();
    mockGetArchivedChatList = MockGetArchivedChatList();
    mockToggleChatArchivedStatus = MockToggleChatArchivedStatus();
    mockDeleteChat = MockDeleteChat();

    chatBloc = ChatBloc(
      getChatListUseCase: mockGetActiveChatList,
      getArchivedChatListUseCase: mockGetArchivedChatList,
      toggleChatUseCase: mockToggleChatArchivedStatus,
      deleteChatUseCase: mockDeleteChat,
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc Tests', () {
    test('initial state should be ChatLoadingState if no chats are preloaded',
        () {
      final chatBloc = ChatBloc(
        getChatListUseCase: mockGetActiveChatList,
        getArchivedChatListUseCase: mockGetArchivedChatList,
        toggleChatUseCase: mockToggleChatArchivedStatus,
        deleteChatUseCase: mockDeleteChat,
        initialChats: null,
      );
      expect(chatBloc.state, isA<ChatLoadingState>());
    });
    test('initial state should be ChatLoadedState if chats are preloaded', () {
      final chatBloc = ChatBloc(
        getChatListUseCase: mockGetActiveChatList,
        getArchivedChatListUseCase: mockGetArchivedChatList,
        toggleChatUseCase: mockToggleChatArchivedStatus,
        deleteChatUseCase: mockDeleteChat,
        initialChats: [
          Contact(
              id: '1',
              userName: 'John Doe',
              avatarUrl: '',
              lastMessage: '',
              lastMessageCreatedTime: DateTime.now(),
              isArchived: false,
              isRead: false),
        ],
      );
      expect(chatBloc.state, isA<ChatLoadedState>());
      expect((chatBloc.state as ChatLoadedState).chats.length, 1);
    });

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoadingState, ChatLoadedState] when LoadChatsEvent is successfully handled',
      setUp: () {
        when(() => mockGetActiveChatList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockGetActiveChatList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoadingState, ChatErrorState] when LoadChatsEvent fails to fetch the chat list data',
      setUp: () {
        when(() => mockGetActiveChatList.call())
            .thenThrow(Exception('Error fetching chats'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatErrorState>(),
      ],
      verify: (_) {
        verify(() => mockGetActiveChatList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ArchivedChatLoadingState, ArchivedChatLoadedState] when LoadArchivedChatsEvent is successfully handled',
      setUp: () {
        when(() => mockGetArchivedChatList.call()).thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        isA<ArchivedChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockGetArchivedChatList.call()).called(1);
      },
    );
    blocTest<ChatBloc, ChatState>(
      'should emit [ArchivedChatLoadingState, ChatErrorState] when LoadArchivedChatsEvent fails to fetch the archived chat list data',
      setUp: () {
        when(() => mockGetArchivedChatList.call())
            .thenThrow(Exception('Error fetching archived chats'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        isA<ChatErrorState>(),
      ],
      verify: (_) {
        verify(() => mockGetArchivedChatList.call()).called(1);
      },
    );
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoadingState, ChatLoadedState] when ToggleChatEvent is handled and current state is ChatLoadedState',
      build: () => chatBloc,
      seed: () => ChatLoadedState([
        Contact(
          id: '1',
          userName: 'John Doe',
          avatarUrl: '',
          lastMessage: '',
          lastMessageCreatedTime: DateTime.now(),
          isArchived: false,
          isRead: false,
        ),
      ]),
      setUp: () {
        when(() => mockGetActiveChatList.call()).thenAnswer((_) async => [
              Contact(
                id: '1',
                userName: 'John Doe',
                avatarUrl: '',
                lastMessage: '',
                lastMessageCreatedTime: DateTime.now(),
                isArchived: true,
                isRead: false,
              ),
            ]);
      },
      act: (bloc) => bloc.add(ToggleChatEvent('1')),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockGetActiveChatList.call()).called(1);
      },
    );
    blocTest<ChatBloc, ChatState>(
      'should emit [ArchivedChatLoadingState, ArchivedChatLoadedState] when ToggleChatEvent is handled and current state is ArchivedChatLoadedState',
      build: () => chatBloc,
      seed: () => ArchivedChatLoadedState([
        Contact(
          id: '1',
          userName: 'John Doe',
          avatarUrl: '',
          lastMessage: '',
          lastMessageCreatedTime: DateTime.now(),
          isArchived: true,
          isRead: false,
        ),
      ]),
      setUp: () {
        when(() => mockGetArchivedChatList.call()).thenAnswer((_) async => [
              Contact(
                id: '1',
                userName: 'John Doe',
                avatarUrl: '',
                lastMessage: '',
                lastMessageCreatedTime: DateTime.now(),
                isArchived: false,
                isRead: false,
              ),
            ]);
      },
      act: (bloc) => bloc.add(ToggleChatEvent('1')),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        isA<ArchivedChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockGetArchivedChatList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should call deleteChat and then emit [ArchivedChatLoadingState, ArchivedChatLoadedState] to refresh the archived chat list after DeleteChatEvent is handled',
      setUp: () {
        when(() => mockDeleteChat.call('1')).thenAnswer((_) async => {});

        when(() => mockGetArchivedChatList.call()).thenAnswer((_) async => [
              Contact(
                id: '1',
                userName: 'Archived User',
                avatarUrl: '',
                lastMessage: '',
                lastMessageCreatedTime: DateTime.now(),
                isArchived: true,
                isRead: false,
              )
            ]);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(DeleteChatEvent('1')),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        isA<ArchivedChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockDeleteChat.call('1')).called(1);
        verify(() => mockGetArchivedChatList.call()).called(1);
      },
    );
  });
}
