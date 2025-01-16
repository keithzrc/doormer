import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromMe;
  final MessageType type;
  final String? mediaUrl;
  final int? audioDurationMs;

  MessageModel({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromMe,
    required this.type,
    this.mediaUrl,
    this.audioDurationMs,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  Message toEntity() => Message(
        id: id,
        content: content,
        timestamp: timestamp,
        isFromMe: isFromMe,
        type: type,
        mediaUrl: mediaUrl,
        audioDuration: audioDurationMs != null 
            ? Duration(milliseconds: audioDurationMs!) 
            : null,
      );

  factory MessageModel.fromEntity(Message message) => MessageModel(
        id: message.id,
        content: message.content,
        timestamp: message.timestamp,
        isFromMe: message.isFromMe,
        type: message.type,
        mediaUrl: message.mediaUrl,
        audioDurationMs: message.audioDuration?.inMilliseconds,
      );

  @override
  String toString() => 'MessageModel('
      'id: $id, '
      'content: $content, '
      'timestamp: $timestamp, '
      'isFromMe: $isFromMe, '
      'type: $type, '
      'mediaUrl: $mediaUrl, '
      'audioDurationMs: $audioDurationMs)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          timestamp == other.timestamp &&
          isFromMe == other.isFromMe &&
          type == other.type &&
          mediaUrl == other.mediaUrl &&
          audioDurationMs == other.audioDurationMs;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        id,
        content,
        timestamp,
        isFromMe,
        type,
        mediaUrl,
        audioDurationMs,
      );
}
