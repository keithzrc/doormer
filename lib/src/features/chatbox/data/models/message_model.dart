import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';

class MessageModel {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromMe;
  final MessageType type;
  final String? mediaUrl;
  final Duration? audioDuration;

  MessageModel({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromMe,
    required this.type,
    this.mediaUrl,
    this.audioDuration,
  });

  Message toEntity() => Message(
        id: id,
        content: content,
        timestamp: timestamp,
        isFromMe: isFromMe,
        type: type,
        mediaUrl: mediaUrl,
        audioDuration: audioDuration,
      );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFromMe: json['isFromMe'] as bool,
      type: MessageType.values.firstWhere(
        (e) => e.name == (json['type'] as String).toLowerCase(),
        orElse: () => MessageType.text,
      ),
      mediaUrl: json['mediaUrl'] as String?,
      audioDuration: json['audioDuration'] != null
          ? Duration(milliseconds: json['audioDuration'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isFromMe': isFromMe,
      'type': type.name,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      if (audioDuration != null) 'audioDuration': audioDuration!.inMilliseconds,
    };
  }
}
