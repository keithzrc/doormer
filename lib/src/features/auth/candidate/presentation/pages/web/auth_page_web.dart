import 'package:doormer/src/features/auth/candidate/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/candidate/presentation/pages/web/auth_input_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/core/di/service_locator.dart'; // For DI

class AuthPageWeb extends StatelessWidget {
  const AuthPageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Section: Placeholder for Logo/Branding
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  'LOGO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Right Section: Authentication Form
          Expanded(
            flex: 2,
            child: BlocProvider(
              create: (_) => serviceLocator<AuthBloc>(),
              child: const Center(
                child: SizedBox(
                  width: 400,
                  child: AuthInputForm(), // Form Widget
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
