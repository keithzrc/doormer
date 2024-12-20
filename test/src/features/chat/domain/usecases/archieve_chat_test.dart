import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat_usecases.dart';
import 'archieve_chat_test.mocks.dart';

@GenerateMocks([ContactRepository])
void main() {
  late MockContactRepository mockRepository;
  late ToggleChatArchivedStatus toggleChatStatus;
  late DeleteChat deleteChat;
  late GetSortedArchivedChatList getArchivedList;
  late GetSortedActiveChatList getActiveChatList;

  setUp(() {
    mockRepository = MockContactRepository();
    toggleChatStatus = ToggleChatArchivedStatus(mockRepository);
    deleteChat = DeleteChat(mockRepository);
    getArchivedList = GetSortedArchivedChatList(mockRepository);
    getActiveChatList = GetSortedActiveChatList(mockRepository);
  });

  group('ToggleChatArchivedStatus', () {
    final testContact = Contact(
      id: '1',
      userName: 'Test User',
      avatarUrl: 'test.jpg',
      lastMessage: 'Hello',
      lastMessageCreatedTime: DateTime.now(),
      isArchived: false,
      isRead: true,
    );

    test('should toggle chat archive status', () async {
      when(mockRepository.updateChat(any)).thenAnswer((_) async {});

      final result = await toggleChatStatus.call(testContact);

      verify(mockRepository.updateChat(any)).called(1);
      expect(result.isArchived, true);
      expect(result.id, testContact.id);
    });
  });

  group('DeleteChat', () {
    test('should call repository to delete chat', () async {
      const chatId = '1';
      when(mockRepository.deleteChat(chatId)).thenAnswer((_) async {});

      await deleteChat.call(chatId);

      verify(mockRepository.deleteChat(chatId)).called(1);
    });
  });

  group('GetArchivedChatList', () {
    test('should return list of archived chats', () async {
      final archivedChats = [
        Contact(
          id: '1',
          userName: 'User 1',
          avatarUrl: 'test1.jpg',
          lastMessage: 'Hello',
          lastMessageCreatedTime: DateTime.now(),
          isArchived: true,
          isRead: true,
        ),
      ];

      when(mockRepository.getArchivedChatList())
          .thenAnswer((_) async => archivedChats);

      final result = await getArchivedList.call();

      expect(result, archivedChats);
      verify(mockRepository.getArchivedChatList()).called(1);
    });
  });

  group('GetActiveChatList', () {
    test('should return list of active chats', () async {
      final activeChats = [
        Contact(
          id: '2',
          userName: 'User 2',
          avatarUrl: 'test2.jpg',
          lastMessage: 'Hi',
          lastMessageCreatedTime: DateTime.now(),
          isArchived: false,
          isRead: true,
        ),
      ];

      when(mockRepository.getActiveChatList())
          .thenAnswer((_) async => activeChats);

      final result = await getActiveChatList.call();

      expect(result, activeChats);
      verify(mockRepository.getActiveChatList()).called(1);
    });
  });
}
