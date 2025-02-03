import 'dart:typed_data';

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

  SignupRequested(this.email, this.password, this.userType);

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
class GoogleSignInRequested extends AuthEvent {
  final String idToken;

  GoogleSignInRequested(this.idToken);
}

/// Event triggered when user 'Employer' submits company information
class SignupCompanyInfoRequested extends AuthEvent {
  final String companyName;
  final String nzbn;
  final String companyType;
  final String companySize;
  final String industry;
  final String oriented;

  SignupCompanyInfoRequested(this.companyName, this.nzbn, this.companyType,
      this.companySize, this.industry, this.oriented);
}

class SignupCandidateInfoRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final Uint8List? fileByte;
  final String? fileName;

  SignupCandidateInfoRequested(
      this.firstName, this.lastName, this.fileByte, this.fileName);
}
