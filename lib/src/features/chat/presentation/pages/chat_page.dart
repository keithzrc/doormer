import 'package:flutter/material.dart';
import './archieve_page.dart'; // 导入归档页面

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        leading: IconButton(
          icon: const Icon(Icons.archive), // 左上角归档按钮
          onPressed: () {
            // 点击按钮跳转到归档页面
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArchivePage()),
            );
          },
        ),
      ),
      body: const Center(
        child: Text('Chat Page'), // 主体部分中间显示文本 'Chat Page'
      ),
    );
  }
}

