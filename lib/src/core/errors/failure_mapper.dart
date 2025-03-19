import 'package:dio/dio.dart';
import 'package:doormer/src/core/errors/failure.dart';

Failure genericErrorMapper(dynamic error) {
  if (error is DioException) {
    // Check for connectivity issues.
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure();
    }

    // Check if the response is available.
    final responseData = error.response?.data;
    // If an API returns an error with a status code, use that to decide.
    final statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return ApiFailure(statusCode,
          responseData is String ? responseData : 'Unexpected API response');
    }
    // For 500 range errors or if no specific API error is identified.
    if (responseData is String) {
      return ServerFailure(responseData);
    } else if (responseData is Map) {
      return ServerFailure(responseData['message'] ?? 'Server error occurred');
    }
  }

  // If the error is a database exception, you could catch it here:
  // if (error is DatabaseException) { return const DatabaseFailure(); }

  // Fallback for unexpected exceptions.
  if (error is Exception) {
    return ServerFailure(error.toString());
  }
  return const UnknownFailure();
}
