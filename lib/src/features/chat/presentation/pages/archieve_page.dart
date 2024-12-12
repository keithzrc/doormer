import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/archive_bloc.dart';
import '../bloc/archive_event.dart' as archive_event; // Prefix for events
import '../bloc/archive_state.dart' as archive_state; // Prefix for states
import '../widgets/chat_card.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
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
                )..add(archive_event.LoadArchivedChatsEvent()), // Trigger loading
                child: BlocBuilder<ChatBloc, archive_state.ChatState>(
                  builder: (context, state) {
                    if (state is archive_state.ChatLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is archive_state.ChatErrorState) {
                      return Center(
                        child: Text('Error: ${state.error}'),
                      );
                    }

                    if (state is archive_state.ArchivedChatLoadedState) {
                      final archivedChats = state.archivedChats;

                      if (archivedChats.isEmpty) {
                        return const Center(
                          child: Text('No archived chats found.'),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(16.0), // Consistent padding
                        child: ListView.builder(
                          itemCount: archivedChats.length,
                          itemBuilder: (context, index) {
                            final chat = archivedChats[index];
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
