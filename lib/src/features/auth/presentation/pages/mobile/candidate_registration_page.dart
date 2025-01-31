import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/di/auth_module.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:doormer/src/shared/widgets/mobile/custom_button.dart';
import 'package:doormer/src/shared/widgets/mobile/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CandidateRegistrationPage extends StatefulWidget {
  @override
  _CandidateRegistrationPageState createState() =>
      _CandidateRegistrationPageState();
}

class _CandidateRegistrationPageState extends State<CandidateRegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void _onSignUpPressed() {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      serviceLocator<AuthBloc>().add(SignupCandidateInfoRequested(
        firstName,
        lastName,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: serviceLocator<AuthBloc>(), // Use serviceLocator for Bloc
      listener: (context, state) {
        AppLogger.info('current state is $state');
        if (state is RegisterSuccess) {
          final router = GoRouter.of(context);
          router.go('/main/home'); // Navigate to main home
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Candidate Registration')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Please enter contact information',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              CustomTextField(
                controller: _firstNameController,
                labelText: 'First Name',
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
              ),
              SizedBox(height: 32),
              CustomButton(
                text: 'Sign up',
                onPressed: _onSignUpPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
