import 'package:dio/dio.dart';
import 'package:doormer/src/core/errors/failure.dart';
import 'package:doormer/src/core/errors/failure_mapper.dart';
import 'package:doormer/src/features/auth/errors/auth_failures.dart';

Failure authErrorMapper(dynamic error) {
  if (error is DioException) {
    final responseData = error.response?.data;
    String? errorMessage;

    if (responseData is String) {
      errorMessage = responseData;
    } else if (responseData is Map) {
      final message = responseData['message'];
      if (message is String) {
        errorMessage = message;
      } else {
        errorMessage = responseData.toString();
      }
    } else if (responseData != null) {
      errorMessage = responseData.toString();
    }

    if (errorMessage != null) {
      final trimmed = errorMessage.trim();
      switch (trimmed) {
        case 'user is already registered':
          return const UserAlreadyRegistered();
        case 'wrong email or password':
          return const InvalidCredentials();
        case 'Google Sign-In was cancelled':
          return const GoogleSignInCancelled();
        case 'Failed to retrieve Google ID token':
          return const GoogleTokenFailure();
        case 'Failed to exchange Google ID token for backend tokens':
          return const BackendTokenExchangeFailure();
        default:
          return ServerFailure(trimmed);
      }
    }
  }

  if (error is String) {
    final trimmed = error.trim();
    switch (trimmed) {
      case 'user is already registered':
        return const UserAlreadyRegistered();
      case 'wrong email or password':
        return const InvalidCredentials();
      case 'Google Sign-In was cancelled':
        return const GoogleSignInCancelled();
      case 'Failed to retrieve Google ID token':
        return const GoogleTokenFailure();
      case 'Failed to exchange Google ID token for backend tokens':
        return const BackendTokenExchangeFailure();
      default:
        return ServerFailure(trimmed);
    }
  }

  // Fallback to generic error mapper.
  return genericErrorMapper(error);
}
