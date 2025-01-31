import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:doormer/src/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: BlocProvider<ChatBloc>.value(
        value: mockChatBloc,
        child: const ArchivePage(),
      ),
    );
  }

  testWidgets('ArchivePage shows loading indicator when loading', (tester) async {
    when(() => mockChatBloc.state).thenReturn(ChatLoadingState());
    
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ArchivePage shows error message when error occurs', (tester) async {
    const errorMessage = 'Error message';
    when(() => mockChatBloc.state).thenReturn(ChatErrorState(errorMessage));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('ArchivePage shows empty message when no archived chats', (tester) async {
    when(() => mockChatBloc.state).thenReturn(ChatLoadedState(unarchivedChats: [], archivedChats: []));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('No archived chats found.'), findsOneWidget);
  });
}