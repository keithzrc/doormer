import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';

class MockGetActiveChatList extends Mock implements GetActiveChatList {}

class MockGetArchivedChatList extends Mock implements GetArchivedChatList {}

class MockToggleChatArchivedStatus extends Mock
    implements ToggleChatArchivedStatus {}

class MockDeleteChat extends Mock implements DeleteChat {}

void main() {
  late MockGetActiveChatList mockGetActiveChatList;
  late MockGetArchivedChatList mockGetArchivedChatList;
  late MockToggleChatArchivedStatus mockToggleChatArchivedStatus;
  late MockDeleteChat mockDeleteChat;

  setUp(() {
    mockGetActiveChatList = MockGetActiveChatList();
    mockGetArchivedChatList = MockGetArchivedChatList();
    mockToggleChatArchivedStatus = MockToggleChatArchivedStatus();
    mockDeleteChat = MockDeleteChat();

    reset(mockGetActiveChatList);
    reset(mockGetArchivedChatList);
    reset(mockToggleChatArchivedStatus);
    reset(mockDeleteChat);
  });

  group('ChatPage', () {
    Widget createWidgetUnderTest({Widget? child}) {
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
          ProxyProvider<GetArchivedChatList, ChatArchiveBloc>(
            create: (context) => ChatArchiveBloc(
              getChatListUseCase: mockGetActiveChatList,
              getArchivedChatListUseCase: context.read<GetArchivedChatList>(),
              toggleChatUseCase: context.read<ToggleChatArchivedStatus>(),
              deleteChatUseCase: context.read<DeleteChat>(),
            ),
            update: (context, getArchivedChatList, previous) =>
                previous ??
                ChatArchiveBloc(
                  getChatListUseCase: mockGetActiveChatList,
                  getArchivedChatListUseCase: getArchivedChatList,
                  toggleChatUseCase: context.read<ToggleChatArchivedStatus>(),
                  deleteChatUseCase: context.read<DeleteChat>(),
                ),
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

    testWidgets('renders ChatPage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // 验证基本UI元素是否存在
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Chat Page'), findsOneWidget);
      expect(find.byIcon(Icons.archive), findsOneWidget);
    });

    testWidgets('navigates to ArchivePage when archive icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // 点击归档图标
      await tester.tap(find.byIcon(Icons.archive));
      await tester.pumpAndSettle();

      // 验证是否导航到ArchivePage
      expect(find.byType(ArchivePage), findsOneWidget);
    });
  });
}
