import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doormer/src/features/chat/presentation/pages/chat_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/chat',
    routes: [
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => const ChatPage(),
          ),
        ],
      ),
    ],
  );
}
