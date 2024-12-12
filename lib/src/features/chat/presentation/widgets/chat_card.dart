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
          backgroundImage: chat.avatarUrl.isEmpty
              ? null
              : NetworkImage(chat.avatarUrl),
          child: chat.avatarUrl.isEmpty
              ? Text(
                  chat.userName.isNotEmpty ? chat.userName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        title: Text(
          chat.userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis, 
        ),
        subtitle: Text(
          chat.lastMessage,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis, 
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
        onTap: onTap, // Allow interaction on tap
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
