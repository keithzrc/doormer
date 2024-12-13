import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/archive_bloc.dart';
import '../bloc/archive_event.dart' as chat_event; // Prefix for events
import '../bloc/archive_state.dart' as chat_state; // Prefix for states
import '../widgets/chat_card.dart';
import 'package:doormer/src/features/chat/presentation/pages/archive_page.dart';


class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
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
        constraints: const BoxConstraints(maxWidth: 1600), // Constrain maximum width
        child: Row(
          children: [
            // Left-side chat list with a fixed minimum width of 250px
            SizedBox(
              width: screenWidth > 1000 ? screenWidth * 0.25 : 250, // Minimum 250px
              child: BlocProvider(
                create: (context) => ChatBloc(
                  getChatList: context.read(),
                  getArchivedChatList: context.read(),
                  archiveChat: context.read(),
                  deleteChat: context.read(),
                )..add(chat_event.LoadChatsEvent()), // Trigger loading of non-archived chats
                child: BlocBuilder<ChatBloc, chat_state.ChatState>(
                  builder: (context, state) {
                    if (state is chat_state.ChatLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is chat_state.ChatErrorState) {
                      return Center(
                        child: Text('Error: ${state.error}'),
                      );
                    }

                    if (state is chat_state.ChatLoadedState) {
                      final chats = state.chats.where((chat) => !chat.isArchived).toList();

                      if (chats.isEmpty) {
                        return const Center(
                          child: Text('No chats found.'),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16.0), // Consistent padding
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
            ),

            // Center chat content placeholder (dynamically adjusts to remaining width)
            const Flexible(
              flex: 2,
              child: Center(
                child: Text(
                  'Chat Content Goes Here',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
              ),
            ),

            // Right-side user profile placeholder
            Flexible(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: const Center(
                  child: Text(
                    'User Profile Section',
                    style: TextStyle(fontSize: 24, color: Colors.black),
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
