import 'package:doormer/src/core/signalr_service.dart';
import 'package:flutter/material.dart';
import 'package:doormer/src/core/di/service_locator.dart'; // 引入依赖初始化
import 'package:go_router/go_router.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:logging/logging.dart'; // 添加日志

final _logger = Logger('IdentitySelectionPage');

class IdentitySelectionPage extends StatelessWidget {
  const IdentitySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 添加检查
    assert(serviceLocator.isRegistered<LocalDataSource>(),
        'LocalDataSource is not registered. Did you call initDependencies?');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Identity'),
      ),
      body: FutureBuilder<List<ContactModel>>(
        future: serviceLocator<LocalDataSource>().getAvailableUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            _logger.severe('Error loading users:', snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                title: Text(user.userName),
                onTap: () async {
                  // 重新初始化依赖，更新 userId
                  serviceLocator<SignalRService>().login(user.id.toString());
                  _logger.info('Selected user: ${user.userName} (${user.id})');

                  // 导航到聊天页面
                  if (context.mounted) {
                    context.go('/chat?userId=${user.id}');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
