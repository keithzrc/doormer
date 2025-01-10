import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:doormer/src/core/utils/uuid_converter.dart';

part 'contact_info_entity.freezed.dart';

/// Represents contact information in the chatbox domain.
///
/// This immutable data class encapsulates the essential information about a contact
/// that is displayed in the chat interface.
@freezed
class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    /// Unique identifier for the contact.
    @UuidValueConverter()
    required UuidValue id,

    /// Display name of the contact.
    required String name,

    /// URL of the contact's avatar image.
    required String avatarUrl,

    /// Professional position or role of the contact.
    String? position,

    /// Expected salary range of the contact.
    String? expectedSalary,

    /// Current status of the contact (e.g., 'Active', 'Offline').
    required String status,
  }) = _ContactInfo;
}
