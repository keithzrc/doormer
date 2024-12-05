import 'package:flutter/material.dart';
import '../../data/repositories/chat_repository_impl.dart'; // 导入存储库实现

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRepository = ChatRepositoryImpl(); // 创建ChatRepositoryImpl实例

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: FutureBuilder(
        future: chatRepository.getArchivedList(), // 获取已归档聊天列表
        builder: (context, snapshot) {
          // 检查异步操作的状态
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 数据加载中时显示进度条
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 如果加载时出现错误，则显示错误信息
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // 如果没有数据或数据为空，则显示提示信息
            return const Center(child: Text('No archived chats found.'));
          } else {
            // 数据加载成功，显示归档聊天列表
            final archivedChats = snapshot.data!;

            return ListView.builder(
              itemCount: archivedChats.length,
              itemBuilder: (context, index) {
                final chat = archivedChats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat.avatarUrl),
                  ),
                  title: Text(chat.userName),
                  subtitle: Text(chat.lastMessage),
                );
              },
            );
          }
        },
      ),
    );
  }
}
