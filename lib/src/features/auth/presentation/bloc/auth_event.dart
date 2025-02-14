import 'package:doormer/src/shared/user/user_type.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event triggered when the user submits the signup form with email and password.
class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final UserType userType;

  SignupRequested({
    required this.email,
    required this.password,
    required this.userType,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event triggered when the user submits the login form with email and password.
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String code;

  VerifyEmailRequested({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}

/// Event triggered when the user requests Google Sign-In.
class GoogleSignInRequested extends AuthEvent {
  final String idToken;

  GoogleSignInRequested(this.idToken);
}
