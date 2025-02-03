import 'package:doormer/src/features/chat/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';

class ChatCard extends StatefulWidget {
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
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _hasError = widget.chat.avatarUrl.trim().isEmpty;
  }

  @override
  void didUpdateWidget(ChatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chat.avatarUrl.isEmpty) {
      setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: widget.chat.avatarUrl.trim().isNotEmpty
                    ? NetworkImage(widget.chat.avatarUrl)
                    : null,
                onBackgroundImageError: (_, __) {
                  setState(() => _hasError = true);
                },
                child: _hasError || widget.chat.avatarUrl.trim().isEmpty
                    ? Text(
                        widget.chat.userName.isNotEmpty
                            ? widget.chat.userName[0].toUpperCase()
                            : '?',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
              // Add red dot to users with unread messages
              // TODO: take it out, reusable
              if (!widget.chat.isRead)
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
            widget.chat.userName,
            style: AppTextStyles.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            widget.chat.lastMessage,
            style: AppTextStyles.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: SizedBox(
            width: 48,
            child: Text(
              widget.chat.lastMessageCreatedTime.toIso8601String(),
              style: AppTextStyles.bodySmall,
            ),
          ),
          onTap: () => widget.onTap(widget.chat),
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
          child: Text(widget.isInArchivePage ? 'Unarchive' : 'Archive'),
          onTap: () {
            if (widget.onArchive != null) {
              widget.onArchive(widget.chat);
            }
          },
        ),
      ],
    );
  }
}
