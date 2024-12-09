import 'package:flutter/material.dart';
import '../../data/repositories/file/chat_repo_impl.dart';
import '../../domain/entities/chat_entity.dart';
import '../widgets/chat_card.dart'; 

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRepository = ChatRepositoryImpl();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: Row(
        children: [
          Flexible(
            flex: 2, 
            child: FutureBuilder<List<Chat>>(
              future: chatRepository.getArchivedList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final archivedChats = snapshot.data;

                if (archivedChats == null || archivedChats.isEmpty) {
                  return const Center(
                    child: Text('No archived chats found.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: archivedChats.length,
                  itemBuilder: (context, index) {
                    final chat = archivedChats[index];
                    return ChatCard(
                      chat: chat,
                      onTap: () {
                        // Handle chat card tap
                      },
                    );
                  },
                );
              },
            ),
          ),

          const Expanded(
            flex: 5,
            child: Center(
              child: Text(
                'Chat Content Goes Here',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            ),
          ),

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
    );
  }
}
