import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'contact_entity.freezed.dart';

/// Represents a contact entity in the domain layer.
///
/// This immutable data class encapsulates core business logic related to a contact.
@freezed
class Contact with _$Contact {
  const factory Contact({
    /// Unique identifier for the contact, represented as a UUID.
    required UuidValue id,

    /// Name of the user associated with the contact.
    required String userName,

    /// URL of the user's avatar image.
    required String avatarUrl,

    /// The last message sent or received in the chat associated with the contact.
    required String lastMessage,

    /// The timestamp of when the last message was created.
    DateTime? lastMessageCreatedTime,

    /// Indicates whether the contact's chat is archived.
    required bool isArchived,

    /// Indicates whether the contact's chat has been read.
    required bool isRead,
  }) = _Contact;
}
