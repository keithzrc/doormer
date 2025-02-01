import 'package:uuid/uuid.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';

class MockChatBloc extends Mock implements ChatBloc {
  @override
  Stream<ChatState> get stream => Stream.value(state);
}

void main() {
  late MockChatBloc mockChatBloc;

  setUp(() {
    mockChatBloc = MockChatBloc();
  });

  testWidgets('displays loading indicator when in loading state',
      (tester) async {
    when(() => mockChatBloc.state).thenReturn(ChatLoadingState());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatBloc>.value(
          value: mockChatBloc,
          child: const ArchivePage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays error message when in error state', (tester) async {
    const errorMessage = 'Error loading chats';
    when(() => mockChatBloc.state).thenReturn(ChatErrorState(errorMessage));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatBloc>.value(
          value: mockChatBloc,
          child: const ArchivePage(),
        ),
      ),
    );

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('displays empty message when no archived chats', (tester) async {
    when(() => mockChatBloc.state).thenReturn(
      ChatLoadedState(unarchivedChats: [], archivedChats: []),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatBloc>.value(
          value: mockChatBloc,
          child: const ArchivePage(),
        ),
      ),
    );

    expect(find.text('No archived chats found.'), findsOneWidget);
  });

  testWidgets('displays archived chats when available', (tester) async {
    final testChats = [
      Contact(
        id: UuidValue(const Uuid().v4()),
        userName: 'Test User',
        lastMessage: 'Hello',
        lastMessageCreatedTime: DateTime.now(),
        avatarUrl: '',
        isArchived: true,
        isRead: true,
      ),
    ];

    when(() => mockChatBloc.state).thenReturn(
      ChatLoadedState(unarchivedChats: [], archivedChats: testChats),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatBloc>.value(
          value: mockChatBloc,
          child: const ArchivePage(),
        ),
      ),
    );

    expect(find.byType(ChatCard), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);
  });
}
