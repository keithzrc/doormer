import 'package:doormer/src/core/signalr_service.dart';
import 'package:flutter/material.dart' show MaterialApp, Scaffold, AppBar, Text, Center, CircularProgressIndicator, ListView, ListTile, CircleAvatar, NetworkImage, SnackBar, ScaffoldMessenger, StatelessWidget, Widget, BuildContext;
import 'package:doormer/src/core/di/service_locator.dart'; // 引入依赖初始化
import 'package:go_router/go_router.dart';
import 'package:doormer/src/features/chat/data/datasources/local_data_source.dart';
import 'package:doormer/src/features/chat/data/models/contact_model.dart';
import 'package:logging/logging.dart'; // 添加日志
import 'package:signalr_netcore/signalr_client.dart' as signalr;
import 'package:flutter/widgets.dart' show FutureBuilder, ConnectionState;

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
                  try {
                    // 打印用户ID，检查格式
                    _logger.info('Selected user ID format: ${user.id} (${user.userName})');
                    
                    // 1. 先设置当前用户ID
                    serviceLocator<LocalDataSource>().setCurrentUserId(user.id.toString());
                    _logger.info('Set current user ID: ${user.id}');

                    // 2. 确保 SignalR 连接成功
                    final signalRService = serviceLocator<SignalRService>();
                    final connection = signalRService.hubConnection;
                    if (connection.state != signalr.HubConnectionState.Connected) {
                      await connection.start();
                      _logger.info('SignalR connection started');
                    }

                    // 3. 登录 SignalR
                    await signalRService.login(user.id.toString());
                    _logger.info('SignalR login successful for user: ${user.id}');

                    // 4. 导航到聊天页面
                    if (context.mounted) {
                      context.go('/chat?userId=${user.id}');
                      _logger.info('Navigated to chat page for user: ${user.id}');
                    }
                  } catch (e) {
                    _logger.severe('Error during user selection:', e);
                    // 可以添加错误提示
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error selecting user: ${e.toString()}')),
                      );
                    }
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
