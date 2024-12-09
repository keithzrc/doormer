import 'package:flutter/material.dart';
import '../../data/repositories/file/chat_repo_impl.dart'; // 导入存储库实现

// 聊天卡片Widget，用于显示每个聊天项
class ChatCard extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final String lastMessage;
  final VoidCallback? onTap;

  const ChatCard({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.lastMessage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        title: Text(
          userName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRepository = ChatRepositoryImpl(); // 创建ChatRepositoryImpl实例

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: Row(
        children: [
          // 左侧聊天列表区域
          Flexible(
            flex: 2, // 占整个宽度的 2/10
            child: FutureBuilder(
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
                    padding: const EdgeInsets.all(8.0),
                    itemCount: archivedChats.length,
                    itemBuilder: (context, index) {
                      final chat = archivedChats[index];
                      return ChatCard(
                        userName: chat.userName,
                        avatarUrl: chat.avatarUrl,
                        lastMessage: chat.lastMessage,
                        onTap: () {
                          // 点击每个聊天项的逻辑（可扩展）
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          // 中间聊天内容区域（占位）
          const Expanded(
            flex: 5, // 占整个宽度的 5/10
            child: Center(
              child: Text(
                'Chat Content Goes Here',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            ),
          ),
          // 右侧个人介绍区域（占位）
          Flexible(
            flex: 3, // 占整个宽度的 3/10
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255), // 右侧的背景颜色
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
