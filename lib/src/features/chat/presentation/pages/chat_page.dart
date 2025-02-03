import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart'
    as chat_event; // Prefix for events
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart'
    as chat_state; // Prefix for states
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ChatBloc>(),
      child: _ChatPageContent(),
    );
  }
}

class _ChatPageContent extends StatelessWidget {
  static const double _minChatListWidth = 250.0;
  static const double _breakpointWidth = 1000.0;
  static const double _chatListWidthRatio = 0.25;

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(chat_event.LoadChatsEvent());

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat', style: AppTextStyles.displayMedium),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () {
              final bloc = BlocProvider.of<ChatBloc>(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: bloc,
                    child: const ArchivePage(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Row(
          children: [
            // Left-side chat list with a fixed minimum width of 250px
            SizedBox(
              width: screenWidth > _breakpointWidth
                  ? screenWidth * _chatListWidthRatio
                  : _minChatListWidth,
              child: BlocBuilder<ChatBloc, chat_state.ChatState>(
                builder: (context, state) {
                  if (state is chat_state.ChatLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is chat_state.ChatErrorState) {
                    return Center(
                      child: Text(
                        'Error: ${state.error}',
                        style: AppTextStyles.bodyLarge, // Updated style
                      ),
                    );
                  }

                  if (state is chat_state.ChatLoadedState) {
                    final chats = state.unarchivedChats;

                    if (chats.isEmpty) {
                      return const Center(
                        child: Text(
                          'No chats found.',
                          style: AppTextStyles.bodyMedium, // Updated style
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16.0), // Consistent padding
                      child: ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];
                          return ChatCard(
                            chat: chat,
                            isInArchivePage: false,
                            onTap: (contact) {
                              // TODO: add chat box
                            },
                            onArchive: (contact) {
                              context.read<ChatBloc>().add(
                                    chat_event.ToggleArchiveStatusEvent(
                                        contact),
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
