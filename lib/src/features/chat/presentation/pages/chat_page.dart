import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/core/signalr_service.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/theme/app_text_styles.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_event.dart'
    as chat_event;
import 'package:doormer/src/features/chat/presentation/bloc/chat_state.dart'
    as chat_state;
import 'package:doormer/src/features/chat/presentation/widgets/chat_card.dart';
import 'package:doormer/src/features/chatbox/presentation/page/chatbox_page.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';

final _logger = Logger('ChatPage');

class ChatPage extends StatelessWidget {
  final String userId;

  const ChatPage({super.key, required this.userId, String? selectedChatId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final String? selectedChatId =
        GoRouterState.of(context).pathParameters['id'];

    _logger.info(
        'Current route parameters: ${GoRouterState.of(context).pathParameters}');
    _logger.info('Selected chat ID: $selectedChatId');

    return BlocProvider(
      create: (_) {
        _logger.info('Creating ChatBloc...');
        return serviceLocator<ChatBloc>()..add(chat_event.LoadChatsEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat as $userId',
            style: AppTextStyles.displayMedium,
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
              // Left-side chat list
              SizedBox(
                width: screenWidth > 1000 ? screenWidth * 0.25 : 250,
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
                          style: AppTextStyles.bodyLarge,
                        ),
                      );
                    }

                    if (state is chat_state.ChatLoadedState) {
                      final chats = state.chats
                          .where((chat) => !chat.isArchived)
                          .toList();

                      _logger.info(
                          'Available chat IDs: ${chats.map((c) => c.id).join(', ')}');

                      if (chats.isEmpty) {
                        return const Center(
                          child: Text(
                            'No chats found.',
                            style: AppTextStyles.bodyMedium,
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
                                context.pushReplacement(
                                    '/chat/${chat.id}?userId=$userId');
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

              // Center chatbox
              Flexible(
                flex: 2,
                child: selectedChatId != null
                    ? FutureBuilder<ContactModel?>(
                        future: serviceLocator<LocalDataSource>()
                            .getUserById(selectedChatId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final contact = snapshot.data;
                          return ChatboxPage(
                            userId: userId,
                            contactId: selectedChatId,
                            contactName: contact?.userName ?? 'Unknown User',
                            signalRService: serviceLocator<SignalRService>(),
                          );
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
                      style: AppTextStyles.bodyLarge,
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
