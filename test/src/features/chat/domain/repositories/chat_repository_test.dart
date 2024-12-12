import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';
import 'chat_repository_test.mocks.dart';

void main() {
  late MockChatRepository mockChatRepository;
  setUp(() {
    mockChatRepository = MockChatRepository();
  });

  group('ChatRepository Tests', () {
    final chat1 = Chat(
      id: '1',
      userName: 'John Doe',
      avatarUrl: 'https://example.com/avatar1.png',
      lastMessage: 'Hello!',
      createdTime: DateTime.now(),
      isArchived: false,
    );

    final chat2 = Chat(
      id: '2',
      userName: 'Jane Smith',
      avatarUrl: 'https://example.com/avatar2.png',
      lastMessage: 'Hi!',
      createdTime: DateTime.now(),
      isArchived: true,
    );

    test('getChatList should return a list of chats', () async {
      when(mockChatRepository.getChatList()).thenAnswer((_) async => [chat1, chat2]);
      final result = await mockChatRepository.getChatList();
      expect(result, [chat1, chat2]);
      expect(result.length, 2);
      verify(mockChatRepository.getChatList()).called(1); 
    });

    test('archiveChat should call archiveChat with correct id', () async {
      when(mockChatRepository.archiveChat('1')).thenAnswer((_) async {});
      await mockChatRepository.archiveChat('1');
      verify(mockChatRepository.archiveChat('1')).called(1);
    });

    test('deleteChat should call deleteChat with correct id', () async {
      when(mockChatRepository.deleteChat('1')).thenAnswer((_) async {});
      await mockChatRepository.deleteChat('1');
      verify(mockChatRepository.deleteChat('1')).called(1);
    });

    test('getArchivedList should return a list of archived chats', () async {
      when(mockChatRepository.getArchivedList()).thenAnswer((_) async => [chat2]);
      final result = await mockChatRepository.getArchivedList();
      expect(result, [chat2]);
      expect(result.length, 1);
      expect(result[0].isArchived, true);
      verify(mockChatRepository.getArchivedList()).called(1);
    });
  });
}
