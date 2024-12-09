import 'package:flutter/material.dart';
import '../../domain/entities/chat_entity.dart'; 


class ChatCard extends StatelessWidget {
  final Chat chat;
  final VoidCallback? onTap;

  const ChatCard({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(chat.avatarUrl),
        ),
        title: Text(
          chat.userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          chat.lastMessage,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: chat.createdTime != null
            ? Text(
                _formatTime(chat.createdTime!),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
