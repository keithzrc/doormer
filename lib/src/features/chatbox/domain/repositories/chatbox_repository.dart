import '../entities/message_entity.dart';
import '../entities/contact_info_entity.dart';

/// Defines the contract for the Chatbox repository.
///
/// This interface provides methods to manage messages and contact information
/// in the chatbox domain layer.
abstract class ChatboxRepository {
  /// Retrieves a stream of messages for a specific contact.
  ///
  /// Parameters:
  /// - [contactId]: The unique identifier of the contact.
  ///
  /// Returns:
  /// - A `Stream` that emits a list of messages whenever the chat updates.
  Stream<List<Message>> getMessages(String contactId);

  /// Sends a new message.
  ///
  /// Converts the domain entity (`Message`) to a data model and stores it
  /// in the data source.
  ///
  /// Parameters:
  /// - [message]: The message entity to be sent.
  Future<void> sendMessage(Message message);

  /// Sends a file and creates a corresponding message.
  ///
  /// Parameters:
  /// - [path]: The file path.
  /// - [type]: The type of message (image, audio, etc.).
  Future<void> sendFile(String path, MessageType type);

  /// Retrieves contact information for a specific contact.
  ///
  /// Parameters:
  /// - [contactId]: The unique identifier of the contact.
  ///
  /// Returns:
  /// - A `Future` that resolves to the contact's information.
  Future<ContactInfo> getContactInfo(String contactId);

  /// Deletes a specific message.
  ///
  /// Parameters:
  /// - [messageId]: The unique identifier of the message to delete.
  Future<void> deleteMessage(String messageId);

  /// Updates an existing message.
  ///
  /// Converts the domain entity (`Message`) to a data model and updates
  /// the corresponding data source entry.
  ///
  /// Parameters:
  /// - [message]: The updated message entity.
  Future<void> updateMessage(Message message);
}
