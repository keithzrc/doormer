// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/domain/usecases/auth_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;

  // Constructor injects AuthUseCase and initializes the bloc with AuthInitial state
  AuthBloc({required this.authUseCase}) : super(AuthInitial()) {
    // Registering event handlers for signup and login requests
    on<SignupRequested>(_onSignupRequested);
    on<LoginRequested>(_onLoginRequested);
    on<ConfirmEmailRequested>(_onConfirmEmailRequested);
  }

  /// Handles the SignupRequested event
  Future<void> _onSignupRequested(
      SignupRequested event, Emitter<AuthState> emit) async {
    AppLogger.info('SignupRequested event received: email=${event.email}');

    // Emit loading state before performing signup
    emit(AuthLoading());
    AppLogger.debug('AuthLoading state emitted');

    try {
      // Call signup method on authUseCase and await result
      final user = await authUseCase.signup(event.email, event.password);

      // Emit success state with user data upon successful signup
      emit(AuthSuccess(user));
      AppLogger.info('AuthSuccess state emitted with user: ${user.email}');
    } catch (e, stackTrace) {
      // Handle errors by emitting failure state and logging the error
      emit(AuthFailure(e.toString()));
      AppLogger.error('AuthFailure state emitted with error', e, stackTrace);
    }
  }

  /// Handles the LoginRequested event
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    AppLogger.info('LoginRequested event received: email=${event.email}');

    // Emit loading state before performing login
    emit(AuthLoading());

    try {
      // Call login method on authUseCase and await result
      final user = await authUseCase.login(event.email, event.password);

      // Emit success state with user data upon successful login
      emit(AuthSuccess(user));
      AppLogger.info('AuthSuccess state emitted with user: ${user.email}');
    } catch (e, stackTrace) {
      // Handle errors by emitting failure state and logging the error
      emit(AuthFailure(e.toString()));
      AppLogger.error('AuthFailure state emitted with error', e, stackTrace);
    }
  }

  /// Handles the confirmEmailRequested event
  Future<void> _onConfirmEmailRequested(
      ConfirmEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authUseCase.confirmEmail(event.email, event.code);
      emit(AuthSuccess(null)); // No user data needed for email confirmation
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
