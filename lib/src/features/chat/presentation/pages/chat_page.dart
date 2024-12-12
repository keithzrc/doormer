import 'package:flutter/material.dart';
import './archieve_page.dart'; 

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Text('Chat Page'), 
      ),
    );
  }
}

