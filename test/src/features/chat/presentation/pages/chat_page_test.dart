import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';

class MockGetChatList extends Mock implements GetChatList {}

class MockGetArchivedList extends Mock implements GetArchivedList {}

class MockArchiveChat extends Mock implements ArchiveChat {}

class MockDeleteChat extends Mock implements DeleteChat {}

void main() {
  late MockGetChatList mockGetChatList;
  late MockGetArchivedList mockGetArchivedList;
  late MockArchiveChat mockArchiveChat;
  late MockDeleteChat mockDeleteChat;

  setUp(() {
    mockGetChatList = MockGetChatList();
    mockGetArchivedList = MockGetArchivedList();
    mockArchiveChat = MockArchiveChat();
    mockDeleteChat = MockDeleteChat();

    reset(mockGetChatList);
    reset(mockGetArchivedList);
    reset(mockArchiveChat);
    reset(mockDeleteChat);
  });

  group('ChatPage', () {
    Widget createWidgetUnderTest({Widget? child}) {
      return MultiProvider(
        providers: [
          Provider<GetChatList>(
            create: (_) => mockGetChatList,
          ),
          Provider<GetArchivedList>(
            create: (_) => mockGetArchivedList,
          ),
          Provider<ArchiveChat>(
            create: (_) => mockArchiveChat,
          ),
          Provider<DeleteChat>(
            create: (_) => mockDeleteChat,
          ),
          ProxyProvider<GetArchivedList, ChatArchiveBloc>(
            create: (context) => ChatArchiveBloc(
              getChatListUseCase: mockGetChatList,
              getArchivedChatListUseCase: context.read<GetArchivedList>(),
              archiveChatUseCase: context.read<ArchiveChat>(),
              unarchiveChatUseCase: context.read<UnarchiveChat>(),
              deleteChatUseCase: context.read<DeleteChat>(),
            ),
            update: (context, getArchivedList, previous) =>
                previous ??
                ChatArchiveBloc(
                  getChatListUseCase: mockGetChatList,
                  getArchivedChatListUseCase: getArchivedList,
                  archiveChatUseCase: context.read<ArchiveChat>(),
                  unarchiveChatUseCase: context.read<UnarchiveChat>(),
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
