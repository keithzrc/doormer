import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/confirm_email_page.dart';
import '../presentation/pages/dashboard_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/list/presentation/pages/list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/favourite/presentation/pages/favourite_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/main/home', // Initial Page
    routes: [
      // Auth Routes
      GoRoute(
        path: '/auth',
        builder: (context, state) => AuthPage(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => LoginPage(),
          ),
          GoRoute(
            path: 'signup',
            builder: (context, state) => SignupPage(),
          ),
          GoRoute(
            path: 'confirm-email',
            builder: (context, state) {
              final email = state.uri.queryParameters['email'] ?? '';
              return ConfirmEmailPage(email: email);
            },
          ),
        ],
      ),

      // Main App Routes with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => DashboardPage(child: child),
        routes: [
          GoRoute(
            path: '/main/home',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: HomePage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/main/list',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: ListPage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/main/favourite',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: FavouritePage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/main/inbox',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: ChatPage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: '/main/profile',
            pageBuilder: (context, state) => const CustomTransitionPage(
              child: ProfilePage(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
        ],
      ),
    ],
    // Add error handling
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found!'),
      ),
    ),
  );

  // Fade transition for smooth transitions between main tabs
  static Widget _fadeTransition(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
