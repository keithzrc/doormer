import 'package:doormer/src/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart'; // 修改这里
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart'
    as archive_state;
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';

class MockChatRepository extends Mock implements ContactRepository {}

class MockChatBloc extends MockBloc<ChatEvent, archive_state.ChatState>
    implements ChatBloc {}

void main() {
  late MockChatRepository mockRepository;
  late MockChatBloc mockChatBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    serviceLocator.reset(); // Reset GetIt before each test

    // Create mock instances
    mockRepository = MockChatRepository();
    mockChatBloc = MockChatBloc();

    // Register mocks in GetIt
    serviceLocator
        .registerLazySingleton<ContactRepository>(() => mockRepository);
    serviceLocator.registerLazySingleton<GetArchivedChatList>(
      () => GetArchivedChatList(serviceLocator<ContactRepository>()),
    );
    serviceLocator.registerLazySingleton<ToggleChatArchivedStatus>(
      () => ToggleChatArchivedStatus(serviceLocator<ContactRepository>()),
    );
    serviceLocator.registerLazySingleton<DeleteChat>(
      () => DeleteChat(serviceLocator<ContactRepository>()),
    );
    serviceLocator.registerFactory<ChatBloc>(() => mockChatBloc);
  });

  tearDown(() {
    serviceLocator.reset(); // Ensure a clean state after each test
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: ArchivePage(),
    );
  }

  group('ArchivePage Tests', () {
    testWidgets(
        'should display loading indicator when state is ArchivedChatLoadingState',
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
