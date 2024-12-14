import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/archive_event.dart'
    as chat_event; // Prefix for events
import 'package:doormer/src/features/chat/presentation/bloc/archive_state.dart'
    as chat_state; // Prefix for states
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:doormer/src/features/chat/presentation/widgets/chat_bloc_provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ChatBlocProvider(
      event: chat_event.LoadChatsEvent(), // Provide the event to load chats
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat',
            style: AppTextStyles.displayMedium, // Updated style
          ),
          leading: IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArchivePage()),
              );
            },
          ),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Row(
            children: [
              // Left-side chat list with a fixed minimum width of 250px
              SizedBox(
                width: screenWidth > 1000
                    ? screenWidth * 0.25
                    : 250, // Minimum 250px
                child: BlocBuilder<ChatArchiveBloc, chat_state.ChatState>(
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
                      final chats = state.chats
                          .where((chat) => !chat.isArchived)
                          .toList();

                      if (chats.isEmpty) {
                        return const Center(
                          child: Text(
                            'No chats found.',
                            style: AppTextStyles.bodyMedium, // Updated style
                          ),
                        );
                      }

                      return Padding(
                        padding:
                            const EdgeInsets.all(16.0), // Consistent padding
                        child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return ChatCard(chat: chat);
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
      ),
    );
  }
}
