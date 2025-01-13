import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_bloc.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_event.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_state.dart';
import 'package:doormer/src/features/chatbox/presentation/page/chatbox_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:uuid/uuid.dart';

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}
class MockChatboxBloc extends MockBloc<ChatboxEvent, ChatboxState> 
    implements ChatboxBloc {}

void main() {
  late MockChatBloc mockChatBloc;
  late MockChatboxBloc mockChatboxBloc;
  final contactId = const Uuid().v4();

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // 处理网络图片错误
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return const SizedBox.shrink();
    };
    
    mockChatBloc = MockChatBloc();
    mockChatboxBloc = MockChatboxBloc();

    // 注册 service locator
    serviceLocator.registerFactory<ChatboxBloc>(() => mockChatboxBloc);
  });

  tearDown(() {
    serviceLocator.reset();
  });

  testWidgets('displays first letter of name as avatar', (tester) async {
    // Arrange
    final contact = Contact(
      id: UuidValue(contactId),
      userName: 'Test User',
      avatarUrl: '',
      isRead: true,
      lastMessage: 'Hello',
      lastMessageCreatedTime: DateTime.now(),
      isArchived: false,
    );

    when(() => mockChatBloc.state).thenReturn(
      ChatLoadedState([contact])
    );

    when(() => mockChatboxBloc.state).thenReturn(const MessagesLoading());

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ChatBloc>(
          create: (context) => mockChatBloc,
          child: ChatboxPage(contactId: contactId),
        ),
      ),
    );

    // Assert
    expect(find.text('T'), findsOneWidget);
    
    final CircleAvatar avatar = tester.widget(find.byType(CircleAvatar));
    expect(avatar.backgroundImage, isNull);
  });
}
