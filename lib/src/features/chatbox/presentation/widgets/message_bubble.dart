import 'package:flutter/material.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isFromMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: _buildMessageContent(),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(message.content);
      case MessageType.image:
        return Image.network(
          message.mediaUrl!,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        );
      case MessageType.voice:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow),
            Text('${message.audioDuration?.inSeconds ?? 0}s'),
          ],
        );
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.attach_file),
            Text(message.content),
          ],
        );
      case MessageType.emoji:
        return Text(
          message.content, 
          style: const TextStyle(fontSize: 24),
        );
      default:
        return const Text('Unsupported message type');
    }
  }
}