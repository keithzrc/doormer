import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doormer/src/features/chatbox/domain/usecase/chatbox_usecase.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';
import 'package:doormer/src/features/chatbox/domain/entities/contact_info_entity.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_bloc.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_event.dart';
import 'package:doormer/src/features/chatbox/presentation/bloc/chatbox_state.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';

class MockGetMessages extends Mock implements GetMessages {}
class MockSendMessage extends Mock implements SendMessage {}
class MockSendFile extends Mock implements SendFile {}
class MockGetContactInfo extends Mock implements GetContactInfo {}

// 创建测试用的消息
final _testMessage = Message(
  id: 'test_message_id',
  content: 'test content',
  timestamp: DateTime(2024),
  isFromMe: true,
  type: MessageType.text,
);

void main() {
  late ChatboxBloc bloc;
  late MockGetMessages mockGetMessages;
  late MockSendMessage mockSendMessage;
  late MockSendFile mockSendFile;
  late MockGetContactInfo mockGetContactInfo;

  setUpAll(() {
    registerFallbackValue(_testMessage);
    registerFallbackValue(MessageType.text);
  });

  setUp(() {
    mockGetMessages = MockGetMessages();
    mockSendMessage = MockSendMessage();
    mockSendFile = MockSendFile();
    mockGetContactInfo = MockGetContactInfo();

    bloc = ChatboxBloc(
      getMessages: mockGetMessages,
      sendMessage: mockSendMessage,
      sendFile: mockSendFile,
      getContactInfo: mockGetContactInfo,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('ChatboxBloc', () {
    test('initial state should be ChatboxInitial', () {
      expect(bloc.state, isA<ChatboxInitial>());
    });

    group('LoadMessages', () {
      blocTest<ChatboxBloc, ChatboxState>(
        'emits loading and loaded states when successful',
        build: () {
          when(() => mockGetMessages.call(any()))
              .thenAnswer((_) => Stream.value([_testMessage]));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadMessages('any_id')),
        expect: () => [
          isA<MessagesLoading>(),
          isA<MessagesLoaded>(),
        ],
      );

      blocTest<ChatboxBloc, ChatboxState>(
        'emits loading and error states when failed',
        build: () {
          when(() => mockGetMessages.call(any()))
              .thenAnswer((_) => Stream.error('error'));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadMessages('any_id')),
        expect: () => [
          isA<MessagesLoading>(),
          isA<ChatboxError>(),
        ],
      );
    });

    group('SendMessageEvent', () {
      blocTest<ChatboxBloc, ChatboxState>(
        'emits sending and sent states when successful',
        build: () {
          when(() => mockSendMessage.call(any()))
              .thenAnswer((_) => Future.value());
          return bloc;
        },
        act: (bloc) => bloc.add(SendMessageEvent(_testMessage)),
        expect: () => [
          isA<MessageSending>(),
          isA<MessageSent>(),
        ],
      );

      blocTest<ChatboxBloc, ChatboxState>(
        'emits sending and error states when failed',
        build: () {
          when(() => mockSendMessage.call(any()))
              .thenThrow(Exception('error'));
          return bloc;
        },
        act: (bloc) => bloc.add(SendMessageEvent(_testMessage)),
        expect: () => [
          isA<MessageSending>(),
          isA<ChatboxError>(),
        ],
      );
    });

    group('SendFileEvent', () {
      const testPath = 'test/path/file.jpg';
      const testType = MessageType.image;

      blocTest<ChatboxBloc, ChatboxState>(
        'emits sending and sent states when successful',
        build: () {
          when(() => mockSendFile.call(any(), any()))
              .thenAnswer((_) => Future.value());
          return bloc;
        },
        act: (bloc) => bloc.add(SendFileEvent(testPath, testType)),
        expect: () => [
          isA<MessageSending>(),
          isA<MessageSent>(),
        ],
      );

      blocTest<ChatboxBloc, ChatboxState>(
        'emits sending and error states when failed',
        build: () {
          when(() => mockSendFile.call(any(), any()))
              .thenThrow(Exception('error'));
          return bloc;
        },
        act: (bloc) => bloc.add(SendFileEvent(testPath, testType)),
        expect: () => [
          isA<MessageSending>(),
          isA<ChatboxError>(),
        ],
      );
    });

    group('LoadContactInfo', () {
      final testContactInfo = ContactInfo(
        id: const UuidValueConverter()
            .fromJson('123e4567-e89b-12d3-a456-426614174000'),
        name: 'test',
        avatarUrl: 'test',
        position: 'test',
        expectedSalary: 'test',
        status: 'test',
      );

      blocTest<ChatboxBloc, ChatboxState>(
        'emits loaded state when successful',
        build: () {
          when(() => mockGetContactInfo.call(any()))
              .thenAnswer((_) => Future.value(testContactInfo));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadContactInfo('any_id')),
        expect: () => [
          isA<ContactInfoLoaded>(),
        ],
      );

      blocTest<ChatboxBloc, ChatboxState>(
        'emits error state when failed',
        build: () {
          when(() => mockGetContactInfo.call(any()))
              .thenThrow(Exception('error'));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadContactInfo('any_id')),
        expect: () => [
          isA<ChatboxError>(),
        ],
      );
    });
  });
} 