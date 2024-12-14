import 'package:doormer/src/core/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:doormer/src/features/chat/domain/entities/chat_entity.dart';

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
          backgroundImage:
              chat.avatarUrl.isNotEmpty ? NetworkImage(chat.avatarUrl) : null,
          child: chat.avatarUrl.isEmpty
              ? Text(
                  chat.userName.isNotEmpty
                      ? chat.userName[0].toUpperCase()
                      : '?',
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
                formatTime(chat.createdTime!),
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
}
