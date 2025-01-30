import 'package:doormer/src/shared/user/Entity/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  // final User? user;

  // AuthSuccess(this.user);

  // @override
  // List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// New state for email verification
class AuthEmailVerificationPending extends AuthState {}

class RegisterFailure extends AuthState {
  final String error;

  RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}
