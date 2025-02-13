abstract class Failure {
  final String message;
  Failure(this.message);

  @override
  String toString() => message;
}

// Network-related failures
class NetworkFailure extends Failure {
  NetworkFailure([super.message = "Network error"]);
}

// Server-related failures (e.g., 500 Internal Server Error)
class ServerFailure extends Failure {
  ServerFailure([super.message = "Server error occurred"]);
}

// API Response Failures (e.g., 400 Bad Request, 404 Not Found)
class ApiFailure extends Failure {
  final int statusCode;

  ApiFailure(this.statusCode, [String message = "Unexpected API response"])
      : super("Error $statusCode: $message");
}

// Authentication failures (e.g., Invalid token, Unauthorized access)
class AuthFailure extends Failure {
  AuthFailure([super.message = "Authentication failed"]);
}

// Database / Local Storage failures (e.g., Cache miss, SQLite failure)
class DatabaseFailure extends Failure {
  DatabaseFailure([super.message = "Database error occurred"]);
}

// General unknown failure (catch-all for unexpected errors)
class UnknownFailure extends Failure {
  UnknownFailure([super.message = "An unknown error occurred"]);
}
