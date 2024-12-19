import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart'
    as archive_state;
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';

class MockChatRepository extends Mock implements ChatRepository {}

class MockChatBloc extends MockBloc<ChatEvent, archive_state.ChatState>
    implements ChatArchiveBloc {}

void main() {
  late MockChatRepository mockRepository;
  late ToggleChatArchivedStatus archiveChat;
  late DeleteChat deleteChat;
  late GetArchivedChatList getArchivedList;
  late GetActiveChatList getChatList;
  late MockChatBloc mockChatBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    mockRepository = MockChatRepository();
    archiveChat = ToggleChatArchivedStatus(mockRepository);
    deleteChat = DeleteChat(mockRepository);
    getArchivedList = GetArchivedChatList(mockRepository);
    getChatList = GetActiveChatList(mockRepository);
    mockChatBloc = MockChatBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ToggleChatArchivedStatus>(
            create: (context) => archiveChat,
          ),
          RepositoryProvider<DeleteChat>(
            create: (context) => deleteChat,
          ),
          RepositoryProvider<GetArchivedChatList>(
            create: (context) => getArchivedList,
          ),
          RepositoryProvider<GetActiveChatList>(
            create: (context) => getChatList,
          ),
        ],
        child: BlocProvider<ChatArchiveBloc>.value(
          value: mockChatBloc,
          child: const ArchivePage(),
        ),
      ),
    );
  }

  group('ArchivePage Tests', () {
    testWidgets('显示加载指示器当状态是ChatLoadingState', (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state)
          .thenReturn(archive_state.ChatLoadingState());
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      //Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('显示错误信息当状态是ChatErrorState', (WidgetTester tester) async {
      const errorMessage =
          "type 'Null' is not a subtype of type 'Future<List<Chat>>'";
      when(() => mockChatBloc.state)
          .thenReturn(archive_state.ChatErrorState(errorMessage));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('显示空消息当没有归档的聊天', (WidgetTester tester) async {
      when(() => mockRepository.getArchivedChatList())
          .thenAnswer((_) async => []);
      when(() => mockChatBloc.state)
          .thenReturn(archive_state.ArchivedChatLoadedState([]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      debugPrint('当前 Bloc 状态: ${mockChatBloc.state}');
      debugPrint('当前渲染的所有 Widget:');
      for (var widget in tester.allWidgets) {
        debugPrint('Widget 类型: ${widget.runtimeType}');
        if (widget is Text) {
          debugPrint('Text 内容: "${widget.data}"');
        }
      }

      expect(find.text('No archived chats found.'), findsOneWidget,
          reason: '应该显示空状态文本');
    });

    testWidgets('显示聊天列表当有归档的聊天', (WidgetTester tester) async {
      final archivedChats = [
        Contact(
          id: '1',
          userName: 'Alice',
          avatarUrl: '',
          createdTime: DateTime.now(),
          lastMessage: 'Hello',
          isArchived: true,
          isRead: true,
        ),
        Contact(
          id: '2',
          userName: 'Bob',
          avatarUrl: '',
          createdTime: DateTime.now(),
          lastMessage: 'Hi',
          isArchived: true,
          isRead: true,
        ),
      ];

      when(() => mockChatBloc.state)
          .thenReturn(archive_state.ArchivedChatLoadedState(archivedChats));

      when(() => mockRepository.getArchivedChatList())
          .thenAnswer((_) async => archivedChats);

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(ChatCard), findsNWidgets(2));
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('Hi'), findsOneWidget);
    });
  });
}
