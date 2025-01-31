import 'package:doormer/src/core/utils/uuid_converter.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'contact_model.g.dart';

/// Data model representing a contact in the data layer.
///
/// This class is used for:
/// - Handling JSON serialization and deserialization.
/// - Mapping raw data to/from the domain entity [Contact].
@JsonSerializable()
class ContactModel {
  /// Unique identifier for the contact, represented as a UUID.
  @UuidValueConverter()
  final UuidValue id;

  final int contactId;

  /// Name of the user associated with the contact.
  final String userName;

  /// URL of the user's avatar image.
  final String avatarUrl;

  /// The last message sent or received in the chat associated with the contact.
  final String lastMessage;

  /// The timestamp of when the last message was created.
  final DateTime lastMessageCreatedTime;

  /// Indicates whether the contact's chat is archived.
  final bool isArchived;

  /// Indicates whether the contact's chat has been read.
  final bool isRead;

  /// Constructor for [ContactModel].
  ContactModel({
    required this.id,
    required this.contactId,
    required this.userName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageCreatedTime,
    required this.isArchived,
    required this.isRead,
  }) {
    // Perform validations
    _validateFields();
  }

  /// Private method to validate fields.
  void _validateFields() {
    if (id.toString().isEmpty) {
      throw ArgumentError('ID cannot be null or empty.');
    }
    if (userName.trim().isEmpty) {
      throw ArgumentError('User name cannot be empty.');
    }
    if (avatarUrl.trim().isEmpty) {
      throw ArgumentError('Avatar URL cannot be empty.');
    }
  }

  /// Creates a `ContactModel` instance from JSON.
  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  /// Converts a `ContactModel` instance to JSON.
  Map<String, dynamic> toJson() => _$ContactModelToJson(this);

  /// Converts this model to a domain entity [Contact].
  Contact toEntity(UuidValue userId) {
    return Contact(
      id: id,
      contactId: contactId,
      userName: userName,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage,
      lastMessageCreatedTime: lastMessageCreatedTime,
      isArchived: isArchived,
      isRead: isRead,
    );
  }

  /// Constructs a `ContactModel` from a domain entity [Contact].
  static ContactModel fromEntity(Contact contact) {
    return ContactModel(
      id: contact.id,
      contactId: contact.contactId,
      userName: contact.userName,
      avatarUrl: contact.avatarUrl,
      lastMessage: contact.lastMessage,
      lastMessageCreatedTime: contact.lastMessageCreatedTime,
      isArchived: contact.isArchived,
      isRead: contact.isRead,
    );
  }

  ContactModel copyWith({
    UuidValue? id,
    int? contactId,
    String? userName,
    String? avatarUrl,
    String? lastMessage,
    DateTime? lastMessageCreatedTime,
    bool? isArchived,
    bool? isRead,
  }) {
    return ContactModel(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageCreatedTime:
          lastMessageCreatedTime ?? this.lastMessageCreatedTime,
      isArchived: isArchived ?? this.isArchived,
      isRead: isRead ?? this.isRead,
    );
  }
}
