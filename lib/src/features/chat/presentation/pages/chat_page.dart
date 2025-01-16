import 'package:doormer/src/core/di/service_locator.dart';
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
import 'package:go_router/go_router.dart';
import 'package:doormer/src/features/chatbox/presentation/page/chatbox_page.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ChatPage');

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final String? selectedChatId =
        GoRouterState.of(context).pathParameters['id'];

    _logger.info('Current route parameters: ${GoRouterState.of(context).pathParameters}');
    _logger.info('Selected chat ID: $selectedChatId');

    return BlocProvider(
      create: (_) {
        _logger.info('Creating ChatBloc...');
        return serviceLocator<ChatBloc>()..add(chat_event.LoadChatsEvent());
      },
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
                      final chats = state.chats
                          .where((chat) => !chat.isArchived)
                          .toList();

                      _logger.info('Available chat IDs: ${chats.map((c) => c.id).join(', ')}');

                      if (chats.isEmpty) {
                        return const Center(
                          child: Text(
                            'No chats found.',
                            style: AppTextStyles.bodyMedium, // Updated style
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return InkWell(
                              onTap: () {
                                _logger.info('Navigating to chat: ${chat.id}');
                                context.pushReplacement('/chat/${chat.id}');
                              },
                              child: ChatCard(chat: chat),
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Updated center section with proper error handling
              Flexible(
                flex: 2,
                child: selectedChatId != null
                    ? Builder(
                        builder: (context) {
                          _logger.info('Creating ChatboxPage with ID: $selectedChatId');
                          return ChatboxPage(contactId: selectedChatId);
                        },
                      )
                    : const Center(
                        child: Text(
                          'Select a chat to start messaging',
                          style: AppTextStyles.bodyLarge,
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
