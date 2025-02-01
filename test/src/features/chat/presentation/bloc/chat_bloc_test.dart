import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:uuid/uuid.dart';

class MockGetActiveChatList extends Mock implements GetSortedActiveChatList {}
class MockGetArchivedList extends Mock implements GetSortedArchivedChatList {}
class MockToggleChatArchivedStatus extends Mock implements ToggleChatArchivedStatus {}

void main() {
  late ChatBloc chatBloc;
  late MockGetActiveChatList mockGetChatList;
  late MockGetArchivedList mockGetArchivedList;
  late MockToggleChatArchivedStatus mockToggleChat;
  late Contact testContact;
  late UuidValue testId;
  final testDateTime = DateTime.now();

  setUp(() {
    mockGetChatList = MockGetActiveChatList();
    mockGetArchivedList = MockGetArchivedList();
    mockToggleChat = MockToggleChatArchivedStatus();
    testId = UuidValue(const Uuid().v4());
    
    testContact = Contact(
      id: testId,
      userName: 'Test User',
      avatarUrl: 'test.jpg',
      lastMessage: 'Hello',
      lastMessageCreatedTime: testDateTime,
      isArchived: false,
      isRead: true,
    );

    chatBloc = ChatBloc(
      getChatListUseCase: mockGetChatList,
      getArchivedChatListUseCase: mockGetArchivedList,
      toggleChatUseCase: mockToggleChat,
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  test('initial state should be ChatLoadingState', () {
    expect(chatBloc.state, isA<ChatLoadingState>());
  });

  group('LoadChatsEvent', () {
    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoadingState, ChatLoadedState] when LoadChatsEvent succeeds',
      setUp: () {
        when(() => mockGetChatList.call(userId))
            .thenAnswer((_) async => [testContact]);
        when(() => mockGetArchivedList.call(userId))
            .thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>()
            .having((state) => state.unarchivedChats.length, 'unarchived chats', 1)
            .having((state) => state.archivedChats.length, 'archived chats', 0),
      ],
      verify: (_) {
        verify(() => mockGetChatList.call(userId)).called(1);
        verify(() => mockGetArchivedList.call(userId)).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoadingState, ChatErrorState] when LoadChatsEvent fails',
      setUp: () {
        when(() => mockGetChatList.call(userId))
            .thenThrow(Exception('Failed to load chats'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatErrorState>(),
      ],
    );
  });

  group('LoadArchivedChatsEvent', () {
    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoadingState, ChatLoadedState] when LoadArchivedChatsEvent succeeds',
      setUp: () {
        when(() => mockGetChatList.call(userId))
            .thenAnswer((_) async => []);
        when(() => mockGetArchivedList.call(userId))
            .thenAnswer((_) async => [testContact]);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>()
            .having((state) => state.unarchivedChats.length, 'unarchived chats', 0)
            .having((state) => state.archivedChats.length, 'archived chats', 1),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits [ChatLoadingState, ChatErrorState] when LoadArchivedChatsEvent fails',
      setUp: () {
        when(() => mockGetChatList.call(userId))
            .thenAnswer((_) async => []);
        when(() => mockGetArchivedList.call(userId))
            .thenThrow(Exception('Failed to load archived chats'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(LoadArchivedChatsEvent()),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatErrorState>(),
      ],
    );
  });

  group('ToggleArchiveStatusEvent', () {
    blocTest<ChatBloc, ChatState>(
      'emits correct states when ToggleArchiveStatusEvent succeeds',
      setUp: () {
        when(() => mockToggleChat.call(userId, testContact))
            .thenAnswer((_) async => testContact);
        when(() => mockGetChatList.call(userId))
            .thenAnswer((_) async => [testContact]);
        when(() => mockGetArchivedList.call(userId))
            .thenAnswer((_) async => []);
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(ToggleArchiveStatusEvent(testContact)),
      expect: () => [
        isA<ChatLoadingState>(),
        isA<ChatLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockToggleChat.call(userId, testContact)).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'emits [ChatErrorState] when ToggleArchiveStatusEvent fails',
      setUp: () {
        when(() => mockToggleChat.call(userId, testContact))
            .thenThrow(Exception('Failed to toggle archive status'));
      },
      build: () => chatBloc,
      act: (bloc) => bloc.add(ToggleArchiveStatusEvent(testContact)),
      expect: () => [
        isA<ChatErrorState>(),
      ],
    );
  });
}

