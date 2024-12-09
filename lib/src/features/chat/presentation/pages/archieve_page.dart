import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/archive_bloc.dart'; 
import '../bloc/archive_event.dart' as archive_event; 
import '../bloc/archive_state.dart' as archive_state; 
import '../widgets/chat_card.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: BlocProvider(
        create: (context) => ChatBloc(
          getChatList: context.read(),
          getArchivedChatList: context.read(),
          archiveChat: context.read(),
          deleteChat: context.read(),
        )..add(archive_event.LoadArchivedChatsEvent()), 
        child: Row(
          children: [
            Flexible(
              flex: 2,
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

                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: archivedChats.length,
                      itemBuilder: (context, index) {
                        final chat = archivedChats[index];
                        return ChatCard(chat: chat);
                      },
                    );
                  }

                  // Fallback for unexpected state
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Center placeholder for chat content
            const Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  'Chat Content Goes Here',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
              ),
            ),

            // Right-side user profile placeholder
            Flexible(
              flex: 3,
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
