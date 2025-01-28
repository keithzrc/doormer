import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event triggered when the user presses the Google sign-in button.
class GoogleSignInPressed extends AuthEvent {}

/// Event triggered when the user submits the signup form with email and password.
class SignupRequested extends AuthEvent {
  final String email;
  final String password;

  SignupRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

/// Event triggered when the user submits the login form with email and password.
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class VerifyEmailRequested extends AuthEvent {
  final String email;
  final String code;

  VerifyEmailRequested(this.email, this.code);

  @override
  List<Object?> get props => [email, code];
}

/// Event triggered when the user requests Google Sign-In.
class GoogleSignInRequested extends AuthEvent {}

/// Event triggered when user 'Employer' submits company information
class SignupCompanyInfoRequested extends AuthEvent {}
