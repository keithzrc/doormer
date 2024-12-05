// chat_page.dart
import 'package:flutter/material.dart';

// ChatPage class represents the main chat screen
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: IconButton(
          icon: const Icon(Icons.archive), // Archive icon in the top-left corner
          onPressed: () {
            // When the archive button is pressed, navigate to the ArchivePage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArchivePage()),
            );
          },
        ),
      ),
      body: const Center(
        child: Text('Chat Page'), // Placeholder text for the chat page
      ),
    );
  }
}

// ArchivePage class represents the archive screen that users navigate to
class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'), // Title for the archive page
      ),
      body: const Center(
        child: Text('This is the Archive Page'), // Placeholder text for the archive page
      ),
    );
  }
}
