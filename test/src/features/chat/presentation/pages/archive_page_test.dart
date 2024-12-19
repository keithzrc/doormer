import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';  // 修改这里
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart'
    as archive_state;
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';

class MockChatRepository extends Mock implements ContactRepository {}

class MockChatBloc extends MockBloc<ChatEvent, archive_state.ChatState>
    implements ChatBloc {}

void main() {
  late MockChatRepository mockRepository;
  late ToggleChatArchivedStatus archiveChat;
  late DeleteChat deleteChat;
  late GetArchivedChatList getArchivedList;
  late GetActiveChatList getChatList;
  late MockChatBloc mockChatBloc;
  final getIt = GetIt.instance;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    mockRepository = MockChatRepository();
    archiveChat = ToggleChatArchivedStatus(mockRepository);
    deleteChat = DeleteChat(mockRepository);
    getArchivedList = GetArchivedChatList(mockRepository);
    getChatList = GetActiveChatList(mockRepository);
    mockChatBloc = MockChatBloc();

    if (getIt.isRegistered<ChatBloc>()) {
      getIt.unregister<ChatBloc>();
    }
    getIt.registerFactory<ChatBloc>(() => mockChatBloc);
  });

  tearDown(() {
    getIt.reset();
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
        child: BlocProvider<ChatBloc>.value(
          value: mockChatBloc,
          child: const ArchivePage(),
        ),
      ),
    );
  }

  group('ArchivePage Tests', () {
    testWidgets('should display loading indicator when state is ArchivedChatLoadingState', 
        (WidgetTester tester) async {
      // Arrange
      when(() => mockChatBloc.state)
          .thenReturn(archive_state.ArchivedChatLoadingState());
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      
      // Debug
      debugPrint('Current Bloc State: ${mockChatBloc.state}');
      debugPrint('Current Rendered Widgets:');
      for (var widget in tester.allWidgets) {
        debugPrint('Widget Type: ${widget.runtimeType}');
      }
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget,
          reason: 'Loading state should display CircularProgressIndicator');
    });

    testWidgets('should display error message when state is ChatErrorState', 
        (WidgetTester tester) async {
      const errorMessage =
          "type 'Null' is not a subtype of type 'Future<List<Chat>>'";
      when(() => mockChatBloc.state)
          .thenReturn(archive_state.ChatErrorState(errorMessage));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });

    testWidgets('should display empty message when no archived chats', 
        (WidgetTester tester) async {
      when(() => mockRepository.getArchivedChatList())
          .thenAnswer((_) async => []);
      when(() => mockChatBloc.state)
          .thenReturn(archive_state.ArchivedChatLoadedState([]));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      debugPrint('Current Bloc State: ${mockChatBloc.state}');
      debugPrint('Current Rendered Widgets:');
      for (var widget in tester.allWidgets) {
        debugPrint('Widget Type: ${widget.runtimeType}');
        if (widget is Text) {
          debugPrint('Text Content: "${widget.data}"');
        }
      }

      expect(find.text('No archived chats found.'), findsOneWidget,
          reason: 'Should display empty state text');
    });

    testWidgets('should display chat list when there are archived chats', 
        (WidgetTester tester) async {
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
