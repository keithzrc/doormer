import 'package:doormer/src/features/auth/presentation/pages/mobile/confirm_email_page.dart';
import 'package:doormer/src/features/auth/presentation/pages/mobile/login_page.dart';
import 'package:doormer/src/features/auth/presentation/pages/mobile/signup_page.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/activation_page_web.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/auth_page_web.dart';
import 'package:doormer/src/features/auth/presentation/pages/web/pending_verification_page_web.dart';
import 'package:doormer/src/features/chat/presentation/pages/chat_page.dart';
import 'package:doormer/src/features/home/candidate/presentation/pages/home_page.dart';
import 'package:doormer/src/features/registration/presentation/pages/signup_candidate_info_page_web.dart';
import 'package:doormer/src/features/registration/presentation/pages/signup_company_info_page_web.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
              path: 'company-registration',
              builder: (context, state) => const SignUpCompanyInfoPageWeb()),
          GoRoute(
              path: 'candidate-registration',
              builder: (context, state) => SignUpCandidateInfoPageWeb()),
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

    // redirect: (context, state) {
    //   final sessionState = context.read<GlobalSessionBloc>().state;

    //   debugPrint("Redirect function triggered");
    //   debugPrint("Current Route: ${state.fullPath}");
    //   debugPrint("Session State: $sessionState");

    //   // If user is NOT logged in, redirect to `/auth`
    //   if (sessionState is! SessionActiveState) {
    //     debugPrint("User is NOT logged in. Redirecting to /auth");
    //     return '/auth';
    //   }

    //   final user = sessionState.user;
    //   final accountStatus = user.accountStatus;
    //   final userType = user.userType;

    //   /// ======================== CANDIDATE REDIRECTION ========================
    //   if (userType == UserType.candidate) {
    //     if (accountStatus == AccountStatus.partial &&
    //         state.matchedLocation != '/auth/candidate-registration') {
    //       debugPrint(
    //           "Candidate has not completed profile. Redirecting to /auth/candidate-registration.");
    //       return '/auth/candidate-registration';
    //     }
    //     if (accountStatus == AccountStatus.inactive &&
    //         state.matchedLocation != '/account-activation') {
    //       debugPrint(
    //           "Inactive candidate detected. Redirecting to /account-activation.");
    //       return '/account-activation';
    //     }
    //     if ((accountStatus == AccountStatus.pending ||
    //             accountStatus == AccountStatus.active) &&
    //         !state.matchedLocation.startsWith('/main')) {
    //       debugPrint("Candidate is verified. Redirecting to /main/home.");
    //       return '/main/home';
    //     }
    //   }

    //   /// ======================== EMPLOYER REDIRECTION ========================
    //   if (userType == UserType.employer) {
    //     if (accountStatus == AccountStatus.partial &&
    //         state.matchedLocation != '/auth/company-registration') {
    //       debugPrint(
    //           "Employer has not completed profile. Redirecting to /auth/company-registration.");
    //       return '/auth/company-registration';
    //     }
    //     if (accountStatus == AccountStatus.inactive &&
    //         state.matchedLocation != '/account-activation') {
    //       debugPrint(
    //           "Inactive employer detected. Redirecting to /account-activation.");
    //       return '/account-activation';
    //     }
    //     if ((accountStatus == AccountStatus.pending ||
    //             accountStatus == AccountStatus.active) &&
    //         !state.matchedLocation.startsWith('/main')) {
    //       debugPrint("Employer is verified. Redirecting to /main/home.");
    //       return '/main/home';
    //     }
    //   }

    //   /// ======================== PREVENT UNVERIFIED USERS FROM ACCESSING `/main/*` ========================
    //   if ((accountStatus == AccountStatus.partial ||
    //           accountStatus == AccountStatus.inactive) &&
    //       state.matchedLocation.startsWith('/main')) {
    //     debugPrint("Unverified user tried to access /main. Redirecting.");
    //     return accountStatus == AccountStatus.partial
    //         ? (userType == UserType.candidate
    //             ? '/candidate-registration'
    //             : '/employer-registration')
    //         : '/account-activation';
    //   }

    //   debugPrint("No redirect needed. Allowing navigation.");
    //   return null;
    // },
    // Handle unknown routes
    errorBuilder: (context, state) {
      debugPrint('Page not found: ${state.fullPath}');
      return const Scaffold(
        body: Center(child: Text('Page not found!')),
      );
    },
  );
}
