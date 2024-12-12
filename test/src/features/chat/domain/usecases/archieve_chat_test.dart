import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:doormer/src/features/chat/domain/usecases/archive_chat.dart';
import 'archieve_chat_test.mock.dart';

void main() {
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
  });

  test('ArchiveChat should call archiveChat on the repository', () async {
    final useCase = ArchiveChat(mockChatRepository);
    const chatId = '123';

    when(mockChatRepository.archiveChat(chatId)).thenAnswer((_) async {});

    await useCase.call(chatId);

    verify(mockChatRepository.archiveChat(chatId)).called(1);
  });
}
