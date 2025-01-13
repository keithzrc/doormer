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
            if (!chat.isRead)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '2', // dummy number
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
        trailing: SizedBox(
          width: 100,
          child: Text(
            // TODO: format time to be more readable
            chat.lastMessageCreatedTime.toIso8601String(),
            style: AppTextStyles.bodySmall,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
