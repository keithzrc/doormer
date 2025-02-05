part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state
class RegistrationInitial extends RegistrationState {}

/// Registration is in progress
class RegistrationLoading extends RegistrationState {}

/// Company registration successful
class CompanyRegistrationSuccess extends RegistrationState {}

/// Candidate registration successful
class CandidateRegistrationSuccess extends RegistrationState {}

/// Registration failed
class RegistrationFailure extends RegistrationState {
  final String error;

  RegistrationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
