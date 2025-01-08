import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';
import 'chat_bloc_test.mocks.dart';

@GenerateMocks([
  GetSortedActiveChatList,
  GetSortedArchivedChatList,
  DeleteChat,
  ToggleChatArchivedStatus,
])
void main() {
  late ChatBloc bloc;
  late MockGetSortedActiveChatList mockGetChatList;
  late MockGetSortedArchivedChatList mockGetArchivedChatList;
  late MockDeleteChat mockDeleteChat;
  late MockToggleChatArchivedStatus mockToggleChat;
  late Contact testContact;

  setUp(() {
    mockGetChatList = MockGetSortedActiveChatList();
    mockGetArchivedChatList = MockGetSortedArchivedChatList();
    mockDeleteChat = MockDeleteChat();
    mockToggleChat = MockToggleChatArchivedStatus();

    bloc = ChatBloc(
      getChatListUseCase: mockGetChatList,
      getArchivedChatListUseCase: mockGetArchivedChatList,
      deleteChatUseCase: mockDeleteChat,
      toggleChatUseCase: mockToggleChat,
    );

    testContact = Contact(
      id: UuidValue(const Uuid().v4()),
      userName: 'Test User',
      avatarUrl: 'test.png',
      lastMessage: 'Test message',
      lastMessageCreatedTime: DateTime.now(),
      isArchived: false,
      isRead: true,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ChatBloc', () {
    test('initial state is ChatLoadingState', () {
      expect(bloc.state, isA<ChatLoadingState>());
    });

    test('LoadChatsEvent loads chats', () async {
      when(mockGetChatList.call())
          .thenAnswer((_) async => [testContact]);

      bloc.add(LoadChatsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ChatLoadingState>(),
          isA<ChatLoadedState>(),
        ]),
      );
    });

    test('LoadArchivedChatsEvent loads archived chats', () async {
      when(mockGetArchivedChatList.call())
          .thenAnswer((_) async => [testContact]);

      bloc.add(LoadArchivedChatsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ArchivedChatLoadingState>(),
          isA<ArchivedChatLoadedState>(),
        ]),
      );
    });

    test('DeleteChatEvent deletes chat', () async {
      when(mockDeleteChat.call(any))
          .thenAnswer((_) async {});
      when(mockGetArchivedChatList.call())
          .thenAnswer((_) async => []);

      bloc.add(DeleteChatEvent(testContact.id.toString()));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ArchivedChatLoadingState>(),
          isA<ArchivedChatLoadedState>(),
        ]),
      );

      verify(mockDeleteChat.call(any)).called(1);
      verify(mockGetArchivedChatList.call()).called(1);
    });
  });
} 