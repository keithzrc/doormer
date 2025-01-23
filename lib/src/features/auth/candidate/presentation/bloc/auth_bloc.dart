// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/candidate/domain/usecases/auth_usecase.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CandidateAuthUseCase authUseCase;
  final GlobalSessionBloc globalSessionBloc;

  // Constructor injects AuthUseCase and initializes the bloc with AuthInitial state
  AuthBloc({
    required this.authUseCase,
    required this.globalSessionBloc,
  }) : super(AuthInitial()) {
    // Registering event handlers for signup and login requests
    on<SignupRequested>(_onSignupRequested);
    on<LoginRequested>(_onLoginRequested);
    on<VerifyEmailRequested>(_onConfirmEmailRequested);
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
      final user = await authUseCase.signup(
          email: event.email, password: event.password);

      // Dispatch SessionStarted to GlobalSessionBloc
      globalSessionBloc.add(SessionStarted());

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
      final user =
          await authUseCase.login(email: event.email, password: event.password);

      // Dispatch SessionStarted to GlobalSessionBloc
      globalSessionBloc.add(SessionStarted());

      // Emit success state with user data upon successful login
      emit(AuthSuccess(user));
      AppLogger.info('AuthSuccess state emitted with user: ${user.email}');
    } catch (e, stackTrace) {
      // Handle errors by emitting failure state and logging the error
      emit(AuthFailure(e.toString()));
      AppLogger.error('AuthFailure state emitted with error', e, stackTrace);
    }
  }

  /// Handles the verifyEmailRequested event
  Future<void> _onConfirmEmailRequested(
      VerifyEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authUseCase.verifyEmail(email: event.email, code: event.code);
      emit(AuthSuccess(null)); // No user data needed for email verification
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // /// Handles the SetupPasswordRequested event
  // Future<void> _onSetupPasswordRequested(
  //   SetupPasswordRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //   try {
  //     await authUseCase.setupPassword(event.password);
  //     emit(AuthSuccess(null)); // No user data needed for password setup
  //   } catch (e) {
  //     emit(AuthFailure("Password setup failed: ${e.toString()}"));
  //   }
  // }

  // /// Handles manual company signup
  // Future<void> _onManualSignupRequested(
  //   ManualSignupRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   AppLogger.info(
  //       'ManualSignupRequested event received: email=${event.email}, companyName=${event.companyName}, NZBN=${event.nzbn}');

  //   emit(AuthLoading());

  //   try {
  //     // Call the manualSignupCompany method in AuthUseCase
  //     await authUseCase.manualSetupCompany(
  //       email: event.email,
  //       name: event.companyName,
  //       nzbn: event.nzbn,
  //     );

  //     // Transition to email verification state
  //     emit(AuthEmailVerificationPending());
  //     AppLogger.info('AuthEmailVerificationPending state emitted');
  //   } catch (e, stackTrace) {
  //     emit(AuthFailure('Manual signup failed: ${e.toString()}'));
  //     AppLogger.error('ManualSignupRequested failed with error', e, stackTrace);
  //   }
  // }
}
