import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

/// Represents a message in the chat system.
///
/// This immutable data class encapsulates all the information about a single message,
/// including its content, metadata, and type.
@freezed
class Message with _$Message {
  const factory Message({
    /// Unique identifier for the message.
    required String id,

    /// The actual content of the message.
    required String content,

    /// Timestamp when the message was created.
    required DateTime timestamp,

    /// Indicates whether the message was sent by the current user.
    required bool isFromMe,

    /// The type of the message (text, image, file, etc.).
    required MessageType type,

    /// URL for media content (if applicable).
    String? mediaUrl,

    /// Duration for audio messages (if applicable).
    Duration? audioDuration,

    /// The contact ID associated with the message.
    required String contactId,
  }) = _Message;
}

/// Defines the different types of messages that can be sent.
enum MessageType {
  /// Plain text message
  text,

  /// Image message
  image,

  /// File attachment
  file,

  /// Voice message
  voice,

  /// Emoji message
  emoji,

  /// Audio message
  audio,
}
