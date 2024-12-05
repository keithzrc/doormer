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
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(chat.avatarUrl),
                          ),
                          title: Text(
                            chat.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            chat.lastMessage,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          //trailing: Icon(Icons.message, color: Colors.blueAccent),
                          onTap: () {
                            // 点击每个聊天项的逻辑（可扩展）
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // 中间聊天内容区域（占位）
          Expanded(
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
              color: Colors.grey[200], // 右侧的背景颜色
              child: Center(
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
