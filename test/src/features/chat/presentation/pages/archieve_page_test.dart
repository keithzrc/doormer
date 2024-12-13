import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_bloc.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_state.dart' as archive_state;
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';

class MockChatRepository extends Mock implements ChatRepository {}
class MockChatBloc extends MockBloc<ChatEvent, archive_state.ChatState> implements ChatBloc {}

void main() {
  late MockChatRepository mockRepository;
  late ArchiveChat archiveChat;
  late DeleteChat deleteChat;
  late GetArchivedList getArchivedList;
  late GetChatList getChatList;
  late MockChatBloc mockChatBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    mockRepository = MockChatRepository();
    archiveChat = ArchiveChat(mockRepository);
    deleteChat = DeleteChat(mockRepository);
    getArchivedList = GetArchivedList(mockRepository);
    getChatList = GetChatList(mockRepository);
    mockChatBloc = MockChatBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ArchiveChat>(
            create: (context) => archiveChat,
          ),
          RepositoryProvider<DeleteChat>(
            create: (context) => deleteChat,
          ),
          RepositoryProvider<GetArchivedList>(
            create: (context) => getArchivedList,
          ),
          RepositoryProvider<GetChatList>(
            create: (context) => getChatList,
          ),
        ],
        child: BlocProvider<ChatBloc>.value(
          value: mockChatBloc,
          child: const ArchivePage(),
        ),
      ),
    );
  }

  group('ArchivePage Tests', () {
    testWidgets('显示加载指示器当状态是ChatLoadingState', (WidgetTester tester) async {
      when(() => mockChatBloc.state).thenReturn(archive_state.ChatLoadingState());
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('显示错误信息当状态是ChatErrorState', (WidgetTester tester) async {
      const errorMessage = "type 'Null' is not a subtype of type 'Future<List<Chat>>'";
      when(() => mockChatBloc.state).thenReturn(archive_state.ChatErrorState(errorMessage));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));
      
      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('显示空消息当没有归档的聊天', (WidgetTester tester) async {
      when(() => mockRepository.getArchivedList()).thenAnswer((_) async => []);
      when(() => mockChatBloc.state).thenReturn(archive_state.ArchivedChatLoadedState([]));
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      
      debugPrint('当前 Bloc 状态: ${mockChatBloc.state}');
      debugPrint('当前渲染的所有 Widget:');
      tester.allWidgets.forEach((widget) {
        debugPrint('Widget 类型: ${widget.runtimeType}');
        if (widget is Text) {
          debugPrint('Text 内容: "${widget.data}"');
        }
      });
      
      expect(
        find.text('No archived chats found.'),
        findsOneWidget,
        reason: '应该显示空状态文本'
      );
    });

    testWidgets('显示聊天列表当有归档的聊天', (WidgetTester tester) async {
      final archivedChats = [
        Chat(
          id: '1', 
          userName: 'Alice',
          avatarUrl: '',
          createdTime: DateTime.now(), 
          lastMessage: 'Hello', 
          isArchived: true
        ),
        Chat(
          id: '2', 
          userName: 'Bob',
          avatarUrl: '',
          createdTime: DateTime.now(), 
          lastMessage: 'Hi', 
          isArchived: true
        ),
      ];
      
      when(() => mockChatBloc.state).thenReturn(
        archive_state.ArchivedChatLoadedState(archivedChats)
      );

      when(() => mockRepository.getArchivedList())
          .thenAnswer((_) async => archivedChats);
      
      whenListen(
        mockChatBloc,
        Stream.fromIterable([
          archive_state.ChatLoadingState(),
          archive_state.ArchivedChatLoadedState(archivedChats),
        ]),
        initialState: archive_state.ChatLoadingState(),
      );
      
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

  group('UseCase Tests', () {
    test('ArchiveChat should call repository.archiveChat', () async {
      const chatId = '123';
      when(() => mockRepository.archiveChat(any())).thenAnswer((_) async {});
      
      await archiveChat(chatId);
      
      verify(() => mockRepository.archiveChat(chatId)).called(1);
    });

    test('DeleteChat should call repository.deleteChat', () async {
      const chatId = '123';
      when(() => mockRepository.deleteChat(any())).thenAnswer((_) async {});
      
      await deleteChat(chatId);
      
      verify(() => mockRepository.deleteChat(chatId)).called(1);
    });

    test('GetArchivedList should return list of chats', () async {
      final expectedChats = [Chat(id: '1', userName: 'User1', avatarUrl: 'avatar1.jpg', createdTime: DateTime.now(), lastMessage: 'Hello', isArchived: true)];
      when(() => mockRepository.getArchivedList())
          .thenAnswer((_) async => expectedChats);
      
      final result = await getArchivedList();
      
      expect(result, equals(expectedChats));
      verify(() => mockRepository.getArchivedList()).called(1);
    });

    test('GetChatList should return list of chats', () async {
      final expectedChats = [Chat(id: '1', userName: 'User1', avatarUrl: 'avatar1.jpg', createdTime: DateTime.now(), lastMessage: 'Hello', isArchived: false)];
      when(() => mockRepository.getChatList())
          .thenAnswer((_) async => expectedChats);
      
      final result = await getChatList();
      
      expect(result, equals(expectedChats));
      verify(() => mockRepository.getChatList()).called(1);
    });
  });
}
