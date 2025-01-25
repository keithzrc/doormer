import 'package:doormer/src/features/chat/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/chat/domain/entities/contact_entity.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart';

class ChatCard extends StatefulWidget {
  final Contact chat;
  final VoidCallback? onTap;

  const ChatCard({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  void initState() {
    super.initState();
    if (!widget.chat.isRead) {
      context.read<ChatBloc>().add(
            //TODO use var instead of dummy number
            LoadUnreadMessageCountEvent(1),
          );
    }
  }

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
              backgroundImage: widget.chat.avatarUrl.isNotEmpty
                  ? NetworkImage(widget.chat.avatarUrl)
                  : null,
              child: widget.chat.avatarUrl.isEmpty
                  ? Text(
                      widget.chat.userName.isNotEmpty
                          ? widget.chat.userName[0].toUpperCase()
                          : '?',
                      style: AppTextStyles.titleLarge,
                    )
                  : null,
            ),
            if (!widget.chat.isRead)
              BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) =>
                    current is UnreadMessageCountLoadedState ||
                    current is UnreadMessageCountLoadingState,
                builder: (context, state) {
                  if (state is UnreadMessageCountLoadedState) {
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.red, //TODO: AppColors
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            state.count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
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
          width: 100,
          child: Text(
            // TODO: format time to be more readable
            widget.chat.lastMessageCreatedTime.toIso8601String(),
            style: AppTextStyles.bodySmall,
          ),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
