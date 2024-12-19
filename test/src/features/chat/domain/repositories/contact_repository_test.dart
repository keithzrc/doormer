import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/features/chat/domain/repositories/contact_repository.dart';
import 'contact_repository_test.mocks.dart';

@GenerateMocks([ContactRepository])
void main() {
  late MockContactRepository mockContactRepository;

  setUp(() {
    mockContactRepository = MockContactRepository();
  });

  group('ContactRepository Tests', () {
    final contact1 = Contact(
      id: '1',
      userName: 'John Doe',
      avatarUrl: 'https://example.com/avatar1.png',
      lastMessage: 'Hello!',
      createdTime: DateTime.now(),
      isArchived: false,
      isRead: true,
    );

    final contact2 = Contact(
      id: '2',
      userName: 'Jane Smith',
      avatarUrl: 'https://example.com/avatar2.png',
      lastMessage: 'Hi!',
      createdTime: DateTime.now(),
      isArchived: true,
      isRead: false,
    );

    test('getActiveChatList should return a list of active chats', () async {
      when(mockContactRepository.getActiveChatList())
          .thenAnswer((_) async => [contact1]);
      
      final result = await mockContactRepository.getActiveChatList();
      
      expect(result, [contact1]);
      expect(result.length, 1);
      expect(result[0].isArchived, false);
      verify(mockContactRepository.getActiveChatList()).called(1);
    });

    test('getArchivedChatList should return a list of archived chats', () async {
      when(mockContactRepository.getArchivedChatList())
          .thenAnswer((_) async => [contact2]);
      
      final result = await mockContactRepository.getArchivedChatList();
      
      expect(result, [contact2]);
      expect(result.length, 1);
      expect(result[0].isArchived, true);
      verify(mockContactRepository.getArchivedChatList()).called(1);
    });

    test('updateChat should call updateChat with correct contact', () async {
      when(mockContactRepository.updateChat(contact1))
          .thenAnswer((_) async {});
      
      await mockContactRepository.updateChat(contact1);
      
      verify(mockContactRepository.updateChat(contact1)).called(1);
    });

    test('deleteChat should call deleteChat with correct id', () async {
      when(mockContactRepository.deleteChat('1'))
          .thenAnswer((_) async {});
      
      await mockContactRepository.deleteChat('1');
      
      verify(mockContactRepository.deleteChat('1')).called(1);
    });

    test('updateChat should handle errors', () async {
      when(mockContactRepository.updateChat(contact1))
          .thenThrow(Exception('Failed to update chat'));
      
      expect(
        () => mockContactRepository.updateChat(contact1),
        throwsException,
      );
    });

    test('deleteChat should handle errors', () async {
      when(mockContactRepository.deleteChat('1'))
          .thenThrow(Exception('Failed to delete chat'));
      
      expect(
        () => mockContactRepository.deleteChat('1'),
        throwsException,
      );
    });
  });
}
