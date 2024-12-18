import '../repositories/chat_repository.dart';
import '../entities/contact_entity.dart';

/// Use case for toggle a chat.
/// This class toggles the isArchived status of chat and updates with the ChatRepository
class ToggleChatArchivedStatus {
  final ChatRepository repository;

  ToggleChatArchivedStatus(this.repository);

  Future<Contact> call(Contact contact) async {
    final updatedContact = contact.copyWith(isArchived: !contact.isArchived);

    // TODO: maybe just create a updateArchiveStatus(), where it Updates the `isArchived` status of a chat by its ID.
    await repository.updateChat(updatedContact);

    return updatedContact;
  }
}

/// Use case for deleting a chat.
/// This class interacts with the ChatRepository to delete a chat
/// identified by its chatId.
// TODO: Move to centralized/ active chat usecase file
class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<void> call(String chatId) async {
    await repository.deleteChat(chatId);
  }
}

/// Use case for retrieving the list of archived chats.
/// This class interacts with the ChatRepository to fetch all archived chats.
class GetArchivedChatList {
  final ChatRepository repository;

  GetArchivedChatList(this.repository);

  Future<List<Contact>> call() async {
    return await repository.getArchivedChatList();
  }
}

/// Use case for retrieving the list of Active chats.
/// This class interacts with the ChatRepository to fetch all Active chats
// TODO: Move to centralized/ active chat usecase file
class GetActiveChatList {
  final ChatRepository repository;

  GetActiveChatList(this.repository);

  Future<List<Contact>> call() async {
    return await repository.getActiveChatList();
  }
}
