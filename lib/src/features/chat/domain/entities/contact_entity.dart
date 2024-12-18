import 'package:uuid/uuid.dart';

/// Represents a chat entity in the system.
/// This class holds all the necessary information about a chat, including:
/// - [uuid]: Unique identifier for the chat.
/// - [userName]: Name of the user associated with the chat.
/// - [avatarUrl]: URL of the user's avatar image.
/// - [lastMessage]: The last message sent or received in the chat.
/// - [createdTime]: The timestamp of when the chat was created (optional).
/// - [isArchived]: Indicates whether the chat is archived.
class Contact {
  final Uuid id;
  final String userName;
  final String avatarUrl;
  final String lastMessage;
  final DateTime? createdTime;
  final bool isArchived;
  final bool isRead;

  Contact({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.createdTime,
    required this.isArchived,
    required this.isRead,
  });
}