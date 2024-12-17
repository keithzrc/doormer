enum MessageType { text, image, file, voice, emoji }

class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromMe;
  final MessageType type;
  final String? mediaUrl;
  final Duration? audioDuration;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromMe,
    required this.type,
    this.mediaUrl,
    this.audioDuration,
  });
}
