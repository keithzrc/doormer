import 'package:doormer/src/core/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../shared/sessions/bloc/global_session_bloc.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalSessionBloc, GlobalSessionState>(
      listener: (context, state) {
        if (state is SessionExpiredState) {
          // Redirect to login page when session expires
          context.go('/auth');
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Helvetica',
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router, // Attach GoRouter configuration
      ),
    );
  }
}
