import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';

class MockGetActiveChatList extends Mock implements GetActiveChatList {}

class MockGetArchivedChatList extends Mock implements GetArchivedChatList {}

class MockToggleChatArchivedStatus extends Mock implements ToggleChatArchivedStatus {}

class MockDeleteChat extends Mock implements DeleteChat {}

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

void main() {
  late MockGetActiveChatList mockGetActiveChatList;
  late MockGetArchivedChatList mockGetArchivedChatList;
  late MockToggleChatArchivedStatus mockToggleChatArchivedStatus;
  late MockDeleteChat mockDeleteChat;
  late MockChatBloc mockChatBloc;
  final getIt = GetIt.instance;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    mockGetActiveChatList = MockGetActiveChatList();
    mockGetArchivedChatList = MockGetArchivedChatList();
    mockToggleChatArchivedStatus = MockToggleChatArchivedStatus();
    mockDeleteChat = MockDeleteChat();
    mockChatBloc = MockChatBloc();

    when(() => mockChatBloc.state).thenReturn(ChatLoadingState());
    whenListen(
      mockChatBloc,
      Stream.fromIterable([ChatLoadingState()]),
    );

    if (getIt.isRegistered<ChatBloc>()) {
      getIt.unregister<ChatBloc>();
    }
    getIt.registerFactory<ChatBloc>(() => mockChatBloc);
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        Provider<GetActiveChatList>(
          create: (_) => mockGetActiveChatList,
        ),
        Provider<GetArchivedChatList>(
          create: (_) => mockGetArchivedChatList,
        ),
        Provider<ToggleChatArchivedStatus>(
          create: (_) => mockToggleChatArchivedStatus,
        ),
        Provider<DeleteChat>(
          create: (_) => mockDeleteChat,
        ),
      ],
      child: MaterialApp(
        home: const ChatPage(),
        routes: {
          '/archive': (context) => const ArchivePage(),
        },
      ),
    );
  }

  group('ChatPage', () {
    testWidgets('renders ChatPage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Chat'), findsOneWidget);
      expect(find.byIcon(Icons.archive), findsOneWidget);
    });

    testWidgets('navigates to ArchivePage when archive icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.archive));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(ArchivePage), findsOneWidget);
    });
  });
}
