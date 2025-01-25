import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:doormer/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:doormer/src/features/auth/presentation/widgets/web/auth_textfield_web.dart';
import 'package:doormer/src/features/auth/presentation/widgets/web/switch_auth_mode_line.dart';
import 'package:doormer/src/features/auth/utils/auth_validators.dart';

class SignUpPageWeb extends StatelessWidget {
  final VoidCallback onSwitchAuthMode;
  final String userType;

  SignUpPageWeb({
    super.key,
    required this.onSwitchAuthMode,
    required this.userType,
  });

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Dispatch the SignupRequested event
      context.read<AuthBloc>().add(SignupRequested(email, password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Handle successful sign-up or Google Sign-In
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign-Up successful!')),
            );
          } else if (state is AuthFailure) {
            // Display error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
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
                      state is AuthLoading ? null : () => _signUp(context),
                  child: state is AuthLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up'),
                ),
                const SizedBox(height: 16),
                // Google Sign In
                ElevatedButton.icon(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          context.read<AuthBloc>().add(GoogleSignInRequested());
                        },
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Sign up with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          // TODO: Add Apple sign-up logic
                        },
                  icon: const Icon(Icons.apple),
                  label: const Text('Sign up with Apple'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchAuthModeLine(
                  text: "Already have an account? ",
                  actionText: "Login",
                  onPressed: onSwitchAuthMode,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
