abstract class SessionService {
  /// Gets access token from storage
  Future<String?> getAccessToken();

  /// Logsout a user, clears token
  Future<void> logout();

  /// Refreshes token
  Future<String?> refreshToken();

  /// Save access and refresh token
  Future<void> saveTokens(
      {required String accessToken, required String refreshToken});
}
