import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:doormer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';

class MockGetActiveChatList extends Mock implements GetActiveChatList {}

class MockGetArchivedChatList extends Mock implements GetArchivedChatList {}

class MockToggleChatArchivedStatus extends Mock
    implements ToggleChatArchivedStatus {}

class MockDeleteChat extends Mock implements DeleteChat {}

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

void main() {
  late MockGetActiveChatList mockGetActiveChatList;
  late MockGetArchivedChatList mockGetArchivedChatList;
  late MockToggleChatArchivedStatus mockToggleChatArchivedStatus;
  late MockDeleteChat mockDeleteChat;

  setUp(() {
    serviceLocator.reset(); // Reset the service locator before each test

    mockGetActiveChatList = MockGetActiveChatList();
    mockGetArchivedChatList = MockGetArchivedChatList();
    mockToggleChatArchivedStatus = MockToggleChatArchivedStatus();
    mockDeleteChat = MockDeleteChat();

    // Register mocks in the service locator
    serviceLocator
        .registerLazySingleton<GetActiveChatList>(() => mockGetActiveChatList);
    serviceLocator.registerLazySingleton<GetArchivedChatList>(
        () => mockGetArchivedChatList);
    serviceLocator.registerLazySingleton<ToggleChatArchivedStatus>(
        () => mockToggleChatArchivedStatus);
    serviceLocator.registerLazySingleton<DeleteChat>(() => mockDeleteChat);

    // Register ChatBloc with mocked use cases
    serviceLocator.registerFactory<ChatBloc>(() => ChatBloc(
          getChatListUseCase: serviceLocator<GetActiveChatList>(),
          getArchivedChatListUseCase: serviceLocator<GetArchivedChatList>(),
          toggleChatUseCase: serviceLocator<ToggleChatArchivedStatus>(),
          deleteChatUseCase: serviceLocator<DeleteChat>(),
        ));

    reset(mockGetActiveChatList);
    reset(mockGetArchivedChatList);
    reset(mockToggleChatArchivedStatus);
    reset(mockDeleteChat);

    // Mock behavior for the use cases => Returning a list of Contact
    when(() => mockGetActiveChatList()).thenAnswer((_) async => <Contact>[]);
    when(() => mockGetArchivedChatList()).thenAnswer((_) async => <Contact>[]);
  });

  tearDown(() {
    serviceLocator.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: const ChatPage(),
      routes: {
        '/archive': (context) => const ArchivePage(),
      },
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
