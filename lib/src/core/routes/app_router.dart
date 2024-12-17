import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'mobile_router.dart';
import 'web_router.dart';
import 'package:doormer/src/features/chatbox/presentation/page/chatbox_page.dart';

/*

AppRouter serves as the main entry point for the application's routing system. 
It determines whether to use the mobile or web router based on the platform (kIsWeb) 
and delegates the routing setup accordingly.

*/

class AppRouter {
  static GoRouter get router => kIsWeb ? WebRouter.router : MobileRouter.router;
}

final router = GoRouter(
  routes: [
    // ... 其他路由
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) => ChatboxPage(
        contactId: state.pathParameters['id']!,
      ),
    ),
  ],
);
