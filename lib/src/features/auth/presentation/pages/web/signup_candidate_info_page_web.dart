import 'package:doormer/src/core/di/service_locator.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_state.dart'; // Import AuthState
import 'package:doormer/src/shared/widgets/web/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation

class SignUpCandidateInfoPageWeb extends StatefulWidget {
  const SignUpCandidateInfoPageWeb({Key? key}) : super(key: key);

  @override
  _SignUpCandidateInfoPageWebState createState() =>
      _SignUpCandidateInfoPageWebState();
}

class _SignUpCandidateInfoPageWebState
    extends State<SignUpCandidateInfoPageWeb> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AuthBloc>(), // Provide AuthBloc
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            debugPrint("Registration successful. Navigating to /main/home");
            GoRouter.of(context).go('/main/home'); // Navigate on success
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Candidate Info'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Enter Candidate Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  CustomTextFieldWeb(
                    label: 'First Name',
                    hintText: 'Enter your first name',
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFieldWeb(
                    label: 'Last Name',
                    hintText: 'Enter your last name',
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () {
                          // Trigger Bloc event with collected form data
                          context
                              .read<AuthBloc>()
                              .add(SignupCandidateInfoRequested(
                                firstNameController.text,
                                lastNameController.text,
                              ));
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
