import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:uuid/uuid.dart';

/// Defines the contract for the Chat repository.
///
/// This interface provides methods to manage chats in the domain layer.
abstract class ContactRepository {
  /// Retrieves a list of unarchived chats as domain entities (`Contact`).
  ///
  /// Converts internal data models to `Contact` entities before returning.
  ///
  /// Returns:
  /// - A `Future` that resolves to a list of unarchived `Contact` entities.
  Future<List<Contact>> getActiveChatList();

  /// Retrieves a list of archived chats as domain entities (`Contact`).
  ///
  /// Converts internal data models to `Contact` entities before returning.
  ///
  /// Returns:
  /// - A `Future` that resolves to a list of archived `Contact` entities.
  Future<List<Contact>> getArchivedChatList();

  /// Updates an existing chat with the data from the provided `Contact` entity.
  ///
  /// Converts the domain entity (`Contact`) to a data model and updates
  /// the corresponding data source entry.
  ///
  /// Parameters:
  /// - [updatedContact]: The updated `Contact` entity.
  Future<void> updateChat(Contact updatedContact);

  /// Deletes a chat by its ID.
  ///
  /// Parameters:
  /// - [chatId]: The unique identifier of the chat to delete.
  // Future<void> deleteChat(String chatId);

  Future<void> archiveChat(UuidValue id, UuidValue contactId, bool isArchived);
}
