import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:uuid/uuid.dart';

class ContactModel {
  final String id; // UUID as a string
  final String userName;
  final String avatarUrl;
  final String lastMessage;
  final DateTime createdTime;
  final bool isArchived;
  final bool isRead;

  ContactModel({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.createdTime,
    required this.isArchived,
    required this.isRead,
  });

  /// Factory constructor to create a [ContactModel] from JSON.
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    if (!Uuid.isValidUUID(fromString: json['id'])) {
      throw FormatException('Invalid UUID format: ${json['id']}');
    }

    return ContactModel(
      id: json['id'] as String,
      userName: json['userName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      lastMessage: json['lastMessage'] as String,
      createdTime: DateTime.parse(json['createdTime'] as String),
      isArchived: json['isArchived'] as bool,
      isRead: json['isRead'] as bool,
    );
  }

  /// Converts the [ContactModel] to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'createdTime': createdTime.toIso8601String(),
      'isArchived': isArchived,
      'isRead': isRead,
    };
  }

  /// Converts this model to a domain entity [Contact].
  Contact toEntity() {
    if (!Uuid.isValidUUID(fromString: id)) {
      throw FormatException('Invalid UUID format: $id');
    }

    return Contact(
      id: id, // Convert String to Uuid
      userName: userName,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage,
      lastMessageCreatedTime: createdTime,
      isArchived: isArchived,
      isRead: isRead,
    );
  }

  /// Creates a [ContactModel] from a domain entity [Contact].
  factory ContactModel.fromEntity(Contact contact) {
    return ContactModel(
      id: contact.id,
      userName: contact.userName,
      avatarUrl: contact.avatarUrl,
      lastMessage: contact.lastMessage,
      createdTime: contact.lastMessageCreatedTime ?? DateTime.now(),
      isArchived: contact.isArchived,
      isRead: contact.isRead,
    );
  }
}
