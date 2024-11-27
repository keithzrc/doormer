import 'package:doormer/src/core/utils/token_storage.dart';

abstract class SessionService {
  Future<void> logout();
  Future<void> refreshToken(); // For token refresh logic
}

class SessionServiceImpl implements SessionService {
  final TokenStorage _tokenStorage;

  SessionServiceImpl({required TokenStorage tokenStorage})
      : _tokenStorage = tokenStorage;

  @override
  Future<void> logout() async {
    // Clear tokens from secure storage
    await _tokenStorage.clearTokens();

    // Notify the app about the logout (e.g., via a Stream or callback)
    // You can implement a callback or state reset here
  }

  @override
  Future<void> refreshToken() async {
    // TODO: Logic for refreshing tokens (handled below)
  }
}
