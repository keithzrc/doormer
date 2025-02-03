import 'package:doormer/src/features/chat/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';

class ChatCard extends StatelessWidget {
  final Contact chat;
  final Function(Contact) onTap;
  final Function(Contact) onArchive;
  final bool isInArchivePage;

  const ChatCard({
    super.key,
    required this.chat,
    required this.onTap,
    required this.onArchive,
    required this.isInArchivePage,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidUrl = chat.avatarUrl.trim().isNotEmpty;
    
    return GestureDetector(
      onSecondaryTapDown: (details) {
        _showContextMenu(context, details.globalPosition);
      },
      child: Card(
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
                backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(40),
                foregroundImage: hasValidUrl
                    ? NetworkImage(chat.avatarUrl)
                    : null,
                onForegroundImageError: (_, __) => null,
                child: Text(
                  chat.userName.isNotEmpty
                      ? chat.userName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
              // Add red dot to users with unread messages
              // TODO: take it out, reusable
              if (!chat.isRead)
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
          trailing: SizedBox(
            width: 48,
            child: Text(
              formatTime(chat.lastMessageCreatedTime),
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
          onTap: () => onTap(chat),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final RenderBox overlay = 
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: Text(isInArchivePage ? 'Unarchive' : 'Archive'),
          onTap: () {
            onArchive(chat);
          },
        ),
      ],
    );
  }
}
