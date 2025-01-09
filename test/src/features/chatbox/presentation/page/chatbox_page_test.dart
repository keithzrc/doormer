import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/features/chatbox/domain/usecase/chatbox_usecase.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_event.dart';
import 'package:doormer/src/features/chatbox/presentation/page/chatbox_page.dart';
import 'package:doormer/src/features/chatbox/presentation/widgets/message_bubble.dart';
import 'package:doormer/src/features/chatbox/presentation/widgets/message_input_bar.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';

class MockGetMessages extends Mock implements GetMessages {}
class MockSendMessage extends Mock implements SendMessage {}
class MockSendFile extends Mock implements SendFile {}
class MockGetContactInfo extends Mock implements GetContactInfo {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late MockGetMessages mockGetMessages;
  late MockSendMessage mockSendMessage;
  late MockSendFile mockSendFile;
  late MockGetContactInfo mockGetContactInfo;
  final getIt = GetIt.instance;

  final testContactInfo = ContactInfo(
    id: const UuidValueConverter().fromJson('test-id'),
    name: 'Test User',
    avatarUrl: 'test.jpg',
    position: 'Developer',
    expectedSalary: '10k',
    status: 'Online',
  );

  final testMessage = Message(
    id: '1',
    content: 'Test message',
    timestamp: DateTime.now(),
    isFromMe: true,
    type: MessageType.text,
  );

  setUpAll(() {
    registerFallbackValue(MessageType.text);
    registerFallbackValue(testMessage);
    registerFallbackValue('test-id');
    registerFallbackValue(const LoadContactInfo('test-id'));
    registerFallbackValue(const LoadMessages('test-id'));
    registerFallbackValue(SendMessageEvent(testMessage));
    registerFallbackValue(const SendFileEvent('test-path', MessageType.image));
  });

  setUp(() {
    mockGetMessages = MockGetMessages();
    mockSendMessage = MockSendMessage();
    mockSendFile = MockSendFile();
    mockGetContactInfo = MockGetContactInfo();

    when(() => mockGetMessages(any())).thenAnswer(
      (_) => Stream.value([]),
    );

    when(() => mockGetContactInfo(any())).thenAnswer(
      (_) => Future.value(testContactInfo),
    );

    when(() => mockSendMessage(any())).thenAnswer(
      (_) => Future.value(),
    );

    when(() => mockSendFile(any(), any())).thenAnswer(
      (_) => Future.value(),
    );

    getIt.registerFactory<GetMessages>(() => mockGetMessages);
    getIt.registerFactory<SendMessage>(() => mockSendMessage);
    getIt.registerFactory<SendFile>(() => mockSendFile);
    getIt.registerFactory<GetContactInfo>(() => mockGetContactInfo);
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: ChatboxPage(contactId: 'test-id'),
      ),
    );
  }

  group('ChatboxPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loads contact info and messages on creation', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      verify(() => mockGetContactInfo(any())).called(1);
      verify(() => mockGetMessages(any())).called(1);
    });

    testWidgets('shows message list when messages are loaded', (tester) async {
      when(() => mockGetMessages(any())).thenAnswer(
        (_) => Stream.value([testMessage]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(MessageBubble), findsOneWidget);
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('shows empty state when no messages', (tester) async {
      when(() => mockGetMessages(any())).thenAnswer(
        (_) => Stream.value([]),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No messages yet'), findsOneWidget);
    });

    testWidgets('can send text message', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final messageInputBar = find.byType(MessageInputBar);
      expect(messageInputBar, findsOneWidget);

      final messageInputBarWidget = tester.widget<MessageInputBar>(messageInputBar);
      messageInputBarWidget.onSendMessage('Test message', MessageType.text);

      verify(() => mockSendMessage(any())).called(1);
    });

    testWidgets('shows error in snackbar when error occurs', (tester) async {
      when(() => mockGetMessages(any())).thenAnswer(
        (_) => Stream.error('Test error'),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Error: Test error'), findsOneWidget);
    });
  });
}
