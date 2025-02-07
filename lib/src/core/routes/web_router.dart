import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chatbox/presentation/page/identity_selection_page.dart';

class WebRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/select-identity', // 初始页面为身份选择页面
    routes: [
      // 身份选择页面
      GoRoute(
        path: '/select-identity',
        name: 'select-identity',
        builder: (context, state) => const IdentitySelectionPage(),
      ),

      // 主聊天页面
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final userId = state.uri.queryParameters['userId'];
          if (userId == null || userId.isEmpty) {
            return const IdentitySelectionPage();
          }
          return ChatPage(
            userId: userId,
            selectedChatId: null,
          );
        },
      ),

      // 具体聊天对话页面
      GoRoute(
        path: '/chat/:id',
        name: 'chat',
        builder: (context, state) {
          final userId = state.uri.queryParameters['userId'];
          final chatId = state.pathParameters['id'];
          if (userId == null || userId.isEmpty) {
            return const IdentitySelectionPage();
          }
          return ChatPage(
            userId: userId,
            selectedChatId: chatId,
          );
        },
      ),
    ],
    debugLogDiagnostics: true, // 开启调试日志
    errorBuilder: (context, state) {
      // 错误处理页面
      return Scaffold(
        body: Center(
          child: Text('Navigation error: ${state.error}'),
        ),
      );
    },
  );
}
