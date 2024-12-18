import 'package:doormer/src/features/chat/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';

class ChatCard extends StatelessWidget {
  final Contact chat;
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
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: chat.avatarUrl.isNotEmpty
                  ? NetworkImage(chat.avatarUrl)
                  : null,
              child: chat.avatarUrl.isEmpty
                  ? Text(
                      chat.userName.isNotEmpty
                          ? chat.userName[0].toUpperCase()
                          : '?',
                      style: AppTextStyles.titleLarge,
                    )
                  : null,
            ),
            // Add red dot to users with unread messages
            if (chat.isRead == false)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          chat.userName,
          style: AppTextStyles.bodyLarge,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          chat.lastMessage,
          style: AppTextStyles.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: chat.createdTime != null
            ? Text(
                formatTime(chat.createdTime!),
                style: AppTextStyles.bodySmall,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
