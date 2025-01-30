import 'package:doormer/src/features/auth/presentation/pages/mobile/confirm_email_page.dart';
import 'package:doormer/src/features/auth/presentation/pages/mobile/login_page.dart';
import 'package:doormer/src/features/auth/presentation/pages/mobile/signup_page.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/activation_page_web.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/auth_page_web.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/pending_verification_page_web.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/signup_company_info_page_web.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';

/*

WebRouter defines the routing structure and logic specifically for the web platform.

*/

/*
WebRouter defines the routing structure and logic specifically for the web platform.
*/

class WebRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/auth',
    routes: [
      // Authentication Routes (Only for users NOT logged in)
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPageWeb(),
        routes: [
          GoRoute(path: 'login', builder: (context, state) => LoginPage()),
          GoRoute(
              path: 'signup', builder: (context, state) => const SignupPage()),
          GoRoute(
            path: 'confirm-email',
            builder: (context, state) {
              final email = state.uri.queryParameters['email'] ?? '';
              return ConfirmEmailPage(email: email);
            },
          ),
          GoRoute(
              path: 'register-company',
              builder: (context, state) => const SignUpCompanyInfoPageWeb()),
        ],
      ),

      // Dedicated routes for pending and activation (for easier management)
      GoRoute(
          path: '/pending-verification',
          builder: (context, state) => const PendingVerificationPageWeb()),
      GoRoute(
          path: '/account-activation',
          builder: (context, state) => const ActivationPageWeb()),

      // Main Application Routes (Require Authentication)
      GoRoute(
          path: '/main/home', builder: (context, state) => const HomePage()),
      GoRoute(
          path: '/main/inbox', builder: (context, state) => const ChatPage()),
    ],

    redirect: (context, state) {
      final sessionState = context.read<GlobalSessionBloc>().state;

      debugPrint("Redirect function triggered");
      debugPrint("Current Route: ${state.fullPath}");
      debugPrint("Session State: $sessionState");

      // If user is NOT logged in, redirect to `/auth`
      if (sessionState is! SessionActiveState) {
        debugPrint("User is NOT logged in. Redirecting to /auth");
        return '/auth';
      }

      final user = sessionState.user;
      final accountStatus = user.accountStatus;
      final userType = user.userType;

      // If user is Basic, force them to `/auth/register-company`
      if (userType == UserType.basic) {
        if (state.matchedLocation != '/auth/register-company') {
          debugPrint(
              "Basic user detected. Redirecting to /auth/register-company.");
          return '/auth/register-company';
        }
        return null; // Stop further redirects
      }

      // If user is inactive (and NOT basic), redirect them to `/account-activation`
      else if (accountStatus == AccountStatus.inactive &&
          state.matchedLocation != '/account-activation') {
        debugPrint(
            "Inactive user detected. Redirecting to /account-activation.");
        return '/account-activation';
      }

      // If user is pending, redirect them to `/pending-verification`
      else if (accountStatus == AccountStatus.pending &&
          state.matchedLocation != '/pending-verification') {
        debugPrint(
            "Pending user detected. Redirecting to /pending-verification.");
        return '/pending-verification';
      }

      // Prevent pending/inactive users from accessing `/main/*`
      else if ((accountStatus == AccountStatus.pending ||
              accountStatus == AccountStatus.inactive) &&
          state.matchedLocation.startsWith('/main')) {
        debugPrint("Pending/inactive user tried to access /main. Redirecting.");
        return accountStatus == AccountStatus.pending
            ? '/pending-verification'
            : '/account-activation';
      }

      debugPrint("No redirect needed. Allowing navigation.");
      return null;
    },
    // Handle unknown routes
    errorBuilder: (context, state) {
      debugPrint('Page not found: ${state.fullPath}');
      return const Scaffold(
        body: Center(child: Text('Page not found!')),
      );
    },
  );
}
