import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/auth/candidate/presentation/pages/confirm_email_page.dart';
import 'package:doormer/src/features/auth/candidate/presentation/pages/login_page.dart';
import 'package:doormer/src/features/auth/candidate/presentation/pages/signup_page.dart';
import 'package:doormer/src/features/auth/candidate/presentation/pages/web/auth_page_web.dart';
import 'package:doormer/src/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';

/*

WebRouter defines the routing structure and logic specifically for the web platform.

*/

class WebRouter {
  // TODO: Change to th according web UI
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPageWeb(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => LoginPage(),
          ),
          GoRoute(
            path: 'signup',
            builder: (context, state) => const SignupPage(),
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

      // Main App Routes for Web

      // TODO: Change to th according web UI
      GoRoute(
        path: '/main/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/main/inbox',
        builder: (context, state) => MaterialApp(
          home: BlocProvider(
            create: (_) => serviceLocator<ChatBloc>(),
            child: const ChatPage(),
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Page not found!')),
    ),
  );
}
