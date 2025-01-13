import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:uuid/uuid.dart';

class FakeContact extends Fake implements Contact {}

// Mock dependencies
class MockGetChatList extends Mock implements GetSortedActiveChatList {}

class MockGetArchivedList extends Mock implements GetSortedArchivedChatList {}

class MockArchiveChat extends Mock implements ToggleChatArchivedStatus {}

class MockDeleteChat extends Mock implements DeleteChat {}

void main() {
  late ChatBloc chatBloc;
  late MockGetChatList mockGetChatList;
  late MockGetArchivedList mockGetArchivedList;
  late MockArchiveChat mockArchiveChat;
  late MockDeleteChat mockDeleteChat;
  setUpAll(() {
    registerFallbackValue(FakeContact());
  });
  setUp(() {
    mockGetChatList = MockGetChatList();
    mockGetArchivedList = MockGetArchivedList();
    mockArchiveChat = MockArchiveChat();
    mockDeleteChat = MockDeleteChat();

    chatBloc = ChatBloc(
      getChatListUseCase: mockGetChatList,
      getArchivedChatListUseCase: mockGetArchivedList,
      toggleChatUseCase: mockArchiveChat,
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
        getChatListUseCase: mockGetChatList,
        getArchivedChatListUseCase: mockGetArchivedList,
        toggleChatUseCase: mockArchiveChat,
        deleteChatUseCase: mockDeleteChat,
        initialChats: null,
      );
      expect(chatBloc.state, isA<ChatLoadingState>());
    });
    test('initial state should be ChatLoadedState if chats are preloaded', () {
      final chatBloc = ChatBloc(
        getChatListUseCase: mockGetChatList,
        getArchivedChatListUseCase: mockGetArchivedList,
        toggleChatUseCase: mockArchiveChat,
        deleteChatUseCase: mockDeleteChat,
        initialChats: [
          Contact(
              id: UuidValue(const Uuid().v4()),
              userName: 'John Doe',
              avatarUrl: '',
              lastMessage: '',
              lastMessageCreatedTime: DateTime.now(),
              isArchived: false,
              isRead: true),
        ],
      );
      expect(chatBloc.state, isA<ChatLoadedState>());
      expect((chatBloc.state as ChatLoadedState).chats.length, 1);
    });

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatLoadingState, ChatLoadedState] when LoadChatsEvent is successfully handled and state contains returned chats',
      setUp: () {
        when(() => mockGetChatList.call()).thenAnswer(
          (_) async => [
            Contact(
              id: UuidValue(const Uuid().v4()),
              userName: 'Jason',
              avatarUrl: 'avatar.png',
              lastMessage: 'Hello',
              lastMessageCreatedTime: DateTime.now(),
              isArchived: false,
              isRead: true,
            ),
          ],
        );
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        predicate<ChatLoadedState>((state) {
          final chats = state.chats;
          return chats.isNotEmpty &&
              chats[0].userName == 'Jason' &&
              chats[0].lastMessage == 'Hello';
        }),
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
      'should emit [ArchivedChatLoadingState, ArchivedChatLoadedState] when LoadArchivedChatsEvent is successfully handled and state contains returned archived chats',
      setUp: () {
        when(() => mockGetArchivedList.call()).thenAnswer(
          (_) async => [
            Contact(
              id: UuidValue(const Uuid().v4()),
              userName: 'Iris',
              avatarUrl: 'avatar_archived.png',
              lastMessage: 'Archived message',
              lastMessageCreatedTime: DateTime.now(),
              isArchived: true,
              isRead: false,
            ),
          ],
        );
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ArchivedChatLoadingState>(),
        predicate<ArchivedChatLoadedState>((state) {
          final archivedChats = state.archivedChats;
          return archivedChats.isNotEmpty &&
              archivedChats[0].userName == 'Iris' &&
              archivedChats[0].lastMessage == 'Archived message' &&
              archivedChats[0].isArchived == true;
        }),
      ],
      verify: (_) {
        verify(() => mockGetArchivedList.call()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
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

    blocTest<ChatBloc, ChatState>(
      'should call deleteChat and then emit [ArchivedChatLoadingState, ArchivedChatLoadedState] to refresh the archived chat list after DeleteChatEvent is handled',
      setUp: () {
        when(() => mockDeleteChat.call("1")).thenAnswer((_) async => {});
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
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatErrorState] when DeleteChatEvent fails',
      setUp: () {
        when(() => mockDeleteChat.call("1"))
            .thenThrow(Exception("Failed to delete chat"));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(DeleteChatEvent('1')),
      expect: () => [
        isA<ChatErrorState>(),
      ],
      verify: (_) {
        verify(() => mockDeleteChat.call('1')).called(1);
        verifyNever(() => mockGetArchivedList.call());
      },
    );
  });
}
