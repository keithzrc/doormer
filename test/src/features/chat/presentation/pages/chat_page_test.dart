import 'package:uuid/uuid.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';
import 'package:doormer/src/core/di/service_locator.dart';

class MockChatBloc extends Mock implements ChatBloc {
  @override
  Stream<ChatState> get stream => Stream.value(state);

  @override
  Future<void> close() async {
    return;
  }
}

void main() {
  late MockChatBloc mockChatBloc;

  setUpAll(() {
    serviceLocator.reset();
  });

  setUp(() {
    mockChatBloc = MockChatBloc();
    serviceLocator.registerFactory<ChatBloc>(() => mockChatBloc);
  });

  tearDown(() {
    serviceLocator.reset();
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: ChatPage(),
    );
  }

  testWidgets('displays loading indicator when in loading state', (tester) async {
    when(() => mockChatBloc.state).thenReturn(ChatLoadingState());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays error message when in error state', (tester) async {
    const errorMessage = 'Network error';
    when(() => mockChatBloc.state).thenReturn(ChatErrorState(errorMessage));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Error: $errorMessage'), findsOneWidget);
  });

  testWidgets('displays empty message when no chats available', (tester) async {
    when(() => mockChatBloc.state).thenReturn(ChatLoadedState(
      unarchivedChats: [],
      archivedChats: [],
    ));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('No chats found.'), findsOneWidget);
  });

  testWidgets('displays chat list when chats are available', (tester) async {
    final testChats = [
      Contact(
        id: UuidValue(const Uuid().v4()),
        userName: 'Chat 1',
        lastMessage: 'Hello',
        lastMessageCreatedTime: DateTime.now(),
        avatarUrl: '',
        isArchived: false,
        isRead: true,
      ),
      Contact(
        id: UuidValue(const Uuid().v4()),
        userName: 'Chat 2',
        lastMessage: 'Hi',
        lastMessageCreatedTime: DateTime.now(),
        avatarUrl: '',
        isArchived: false,
        isRead: true,
      ),
    ];

    when(() => mockChatBloc.state).thenReturn(ChatLoadedState(
      unarchivedChats: testChats,
      archivedChats: [],
    ));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(ChatCard), findsNWidgets(2));
    expect(find.text('Chat 1'), findsOneWidget);
  });

  testWidgets('filters out archived chats', (tester) async {
    final testChats = [
      Contact(
        id: UuidValue(const Uuid().v4()),
        userName: 'Chat 1',
        lastMessage: 'Hello',
        lastMessageCreatedTime: DateTime.now(),
        avatarUrl: '',
        isArchived: false,
        isRead: true,
      ),
      Contact(
        id: UuidValue(const Uuid().v4()),
        userName: 'Chat 2',
        lastMessage: 'Hi',
        lastMessageCreatedTime: DateTime.now(),
        avatarUrl: '',
        isArchived: true,
        isRead: true,
      ),
    ];

    when(() => mockChatBloc.state).thenReturn(ChatLoadedState(
      unarchivedChats: testChats,
      archivedChats: [],
    ));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(); 

    expect(find.byType(ChatCard), findsOneWidget);
    expect(find.text('Chat 1'), findsOneWidget);
    expect(find.text('Chat 2'), findsNothing);
  });
}