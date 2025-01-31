import 'package:doormer/src/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart'
    as archive_event; // Prefix for events
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart'
    as archive_state; // Prefix for states
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ChatBloc>(),
      child: _ArchivePageContent(),
    );
  }
}

class _ArchivePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 进入页面时加载数据
    context.read<ChatBloc>().add(archive_event.LoadChatsEvent());

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Archive',
          style: AppTextStyles.displayMedium,
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth > 1000 ? screenWidth * 0.25 : 250,
              child: BlocBuilder<ChatBloc, archive_state.ChatState>(
                builder: (context, state) {
                  if (state is archive_state.ChatLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is archive_state.ChatErrorState) {
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  if (state is archive_state.ChatLoadedState) {
                    final archivedChats = state.archivedChats;

                    if (archivedChats.isEmpty) {
                      return const Center(
                        child: Text(
                          'No archived chats found.',
                          style: AppTextStyles.bodyMedium,
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: archivedChats.length,
                        itemBuilder: (context, index) {
                          final chat = archivedChats[index];
                          return ChatCard(
                            chat: chat,
                            isInArchivePage: true,
                            onTap: () {
                              // TODO: Add chat box
                            },
                            onArchive: (contact) {
                              context.read<ChatBloc>().add(
                                    archive_event.ToggleArchiveStatusEvent(contact),
                                  );
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Center chat content placeholder (dynamically adjusts to remaining width)
            const Flexible(
              flex: 2,
              child: Center(
                child: Text(
                  'Chat Content Goes Here',
                  style: AppTextStyles.bodyLarge, // Updated style
                ),
              ),
            ),

            // Right-side user profile placeholder
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'User Profile Section',
                    style: AppTextStyles.bodyLarge, // Updated style
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
