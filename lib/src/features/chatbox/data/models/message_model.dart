import 'package:doormer/src/features/chatbox/domain/entities/message_entity.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.content,
    required super.timestamp,
    required super.isFromMe,
    required super.type,
    super.mediaUrl,
    super.audioDuration,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFromMe: json['isFromMe'] as bool,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
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
      'type': type.toString(),
      'mediaUrl': mediaUrl,
      'audioDuration': audioDuration?.inMilliseconds,
    };
  }
}
