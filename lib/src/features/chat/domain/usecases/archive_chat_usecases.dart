import 'package:uuid/uuid.dart';

import '../repositories/contact_repository.dart';
import '../entities/contact_entity.dart';

/// Use case for toggle a chat.
/// This class toggles the isArchived status of chat and updates with the ChatRepository
class ToggleChatArchivedStatus {
  final ContactRepository repository;

  ToggleChatArchivedStatus(this.repository);

  Future<Contact> call(UuidValue userId, Contact contact) async {
    final updatedContact = contact.copyWith(isArchived: !contact.isArchived);

    await repository.archiveChat(
      userId,
      contact.id,
      !contact.isArchived
    );

    return updatedContact;
  }
}

/// Use case for deleting a chat.
/// This class interacts with the ChatRepository to delete a chat
/// identified by its chatId.
// TODO: Move to centralized/ active chat usecase file
// class DeleteChat {
//   final ContactRepository repository;

//   DeleteChat(this.repository);

//   Future<void> call(String chatId) async {
//     await repository.deleteChat(chatId);
//   }
// }

/// Use case for retrieving the list of archived chats.
/// This class interacts with the ChatRepository to fetch all archived chats.
class GetSortedArchivedChatList {
  final ContactRepository repository;

  GetSortedArchivedChatList(this.repository);

  Future<List<Contact>> call(UuidValue userId) async {
    final chats = await repository.getArchivedChatList(userId);
    chats.sort(
        (a, b) => b.lastMessageCreatedTime.compareTo(a.lastMessageCreatedTime));
    return chats;
  }
}

/// Use case for retrieving the list of Active chats.
/// This class interacts with the ChatRepository to fetch all Active chats
// TODO: Move to centralized/ active chat usecase file
// TODO: Maybe move sorting to presentation UI pages
class GetSortedActiveChatList {
  final ContactRepository repository;

  GetSortedActiveChatList(this.repository);

  Future<List<Contact>> call(UuidValue userId) async {
    final chats = await repository.getActiveChatList(userId);
    chats.sort(
        (a, b) => b.lastMessageCreatedTime.compareTo(a.lastMessageCreatedTime));
    return chats;
  }
}

class GetUnreadMessageCount {
  final ContactRepository repository;

  GetUnreadMessageCount(this.repository);

  Future<int> call(int contactId) async {
    final count = await repository.getUnreadMessageCount(contactId);
    return count;
  }
}
