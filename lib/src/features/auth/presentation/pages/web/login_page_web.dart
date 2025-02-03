import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:doormer/src/features/auth/presentation/widgets/web/auth_textfield_web.dart';
import 'package:doormer/src/features/auth/presentation/widgets/web/switch_auth_mode_line.dart';
import 'package:doormer/src/features/auth/utils/auth_validators.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/Models/account_status.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPageWeb extends StatelessWidget {
  final VoidCallback onSwitchAuthMode;
  final UserType userType;

  LoginPageWeb(
      {super.key, required this.onSwitchAuthMode, required this.userType});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Dispatch the LoginRequested event
      BlocProvider.of<AuthBloc>(context).add(LoginRequested(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                // Trigger navigation based on GlobalSessionBloc
                final sessionState = context.read<GlobalSessionBloc>().state;
                if (sessionState is SessionActiveState) {
                  final user =
                      sessionState.user; // Access User from GlobalSessionBloc
                  final accountStatus = user.accountStatus;
                  final router = GoRouter.of(context);

                  // Navigate based on accountStatus
                  switch (accountStatus) {
                    case AccountStatus.active:
                      router.go('/main/home'); // Navigate to the dashboard
                      break;
                    case AccountStatus.pending:
                      router.go(
                          '/pending-verification'); // Navigate to verification pending page
                      break;
                    case AccountStatus.inactive:
                      router.go(
                          '/account-activation'); // Navigate to the activation page
                      break;
                    case AccountStatus.partial:
                      router.go('/company-registration');
                      break;
                  }
                }
              } else if (state is AuthFailure) {
                // Display error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthTextField(
                    hintText: 'Email',
                    obscureText: false,
                    controller: _emailController,
                    validator: AuthValidators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    hintText: 'Password',
                    obscureText: true,
                    controller: _passwordController,
                    validator: AuthValidators.validatePassword,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        state is AuthLoading ? null : () => _login(context),
                    child: state is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login'),
                  ),
                  const SizedBox(height: 16),
                  _buildSocialButtons(),
                  const SizedBox(height: 16),
                  SwitchAuthModeLine(
                    text: "Don't have an account? ",
                    actionText: "Sign Up",
                    onPressed: onSwitchAuthMode,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Add Google login logic
          },
          icon: const Icon(Icons.g_mobiledata),
          label: const Text('Sign in with Google'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Add Apple login logic
          },
          icon: const Icon(Icons.apple),
          label: const Text('Sign in with Apple'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
