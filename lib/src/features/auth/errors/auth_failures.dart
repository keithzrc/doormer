import 'package:doormer/src/core/errors/failure.dart';

/// Base class for authentication failures
abstract class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Represents a failure when the user is already registered.
class UserAlreadyRegistered extends AuthFailure {
  const UserAlreadyRegistered([super.message = 'User is already registered']);
}

/// Represents a failure when the provided credentials are invalid.
class InvalidCredentials extends AuthFailure {
  const InvalidCredentials([super.message = 'Invalid credentials']);
}

/// Google Sign-In failures.

/// Thrown when the user cancels the Google Sign-In process.
class GoogleSignInCancelled extends Failure {
  const GoogleSignInCancelled([super.message = 'Google Sign-In was cancelled']);
}

/// Thrown when the Google ID token could not be retrieved.
class GoogleTokenFailure extends Failure {
  const GoogleTokenFailure(
      [super.message = 'Failed to retrieve Google ID token']);
}

/// Thrown when the backend fails to exchange the Google ID token for tokens.
class BackendTokenExchangeFailure extends Failure {
  const BackendTokenExchangeFailure(
      [super.message =
          'Failed to exchange Google ID token for backend tokens']);
}
