import 'package:bloc/bloc.dart';
import 'package:doormer/src/core/utils/app_logger.dart';
import 'package:doormer/src/features/auth/domain/usecases/auth_usecase.dart';
import 'package:doormer/src/shared/sessions/bloc/global_session_bloc.dart';
import 'package:doormer/src/shared/user/user_type.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase authUseCase;
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
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  /// Handles the SignupRequested event
  Future<void> _onSignupRequested(
      SignupRequested event, Emitter<AuthState> emit) async {
    AppLogger.info('SignupRequested event received: email=${event.email}');

    // Emit loading state before performing signup
    emit(AuthLoading());
    AppLogger.debug('AuthLoading state emitted');

    final result = await authUseCase.signup(
      email: event.email,
      password: event.password,
      userType: event.userType,
    );

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
        AppLogger.error(
            'AuthFailure state emitted with error: ${failure.message}');
      },
      (user) {
        // Dispatch SessionStarted to GlobalSessionBloc
        globalSessionBloc.add(SessionStarted(user));
        emit(AuthSuccess());
        AppLogger.info('AuthSuccess state emitted with user: ${user.email}');
      },
    );
  }

  /// Handles the LoginRequested event
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    AppLogger.info('LoginRequested event received: email=${event.email}');

    // Emit loading state before performing login
    emit(AuthLoading());

    final result = await authUseCase.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
        AppLogger.error(
            'AuthFailure state emitted with error: ${failure.message}');
      },
      (user) {
        AppLogger.info('User acquired: $user');
        // Dispatch SessionStarted to GlobalSessionBloc
        globalSessionBloc.add(SessionStarted(user));
        emit(AuthSuccess());
        AppLogger.info('AuthSuccess state emitted with user: ${user.email}');
      },
    );
  }

  /// Handles the VerifyEmailRequested event
  Future<void> _onConfirmEmailRequested(
      VerifyEmailRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authUseCase.verifyEmail(
      email: event.email,
      code: event.code,
    );
    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
      },
      (_) {
        emit(AuthSuccess()); // No user data needed for email verification
      },
    );
  }

  /// Handles GoogleSignInRequested event
  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<AuthState> emit) async {
    AppLogger.info('GoogleSignInRequested event received');

    // Emit loading state
    emit(AuthLoading());
    AppLogger.debug('AuthLoading state emitted for Google Sign-In');

    final result = await authUseCase.signInWithGoogle(event.idToken);
    result.fold(
      (failure) {
        emit(AuthFailure(failure.message));
        AppLogger.error(
            'AuthFailure state emitted for Google Sign-In: ${failure.message}');
      },
      (user) {
        // Dispatch SessionStarted to GlobalSessionBloc
        globalSessionBloc.add(SessionStarted(user));
        emit(AuthSuccess());
        AppLogger.info('AuthSuccess state emitted with user: ${user.email}');
      },
    );
  }
}
