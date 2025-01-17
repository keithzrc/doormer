abstract class TokenStorage {
  /// Save the access token
  Future<void> saveAccessToken(String token);

  /// Retrieve the access token
  Future<String?> getAccessToken();

  /// Delete the access token
  Future<void> deleteAccessToken();

  /// Save the refresh token
  Future<void> saveRefreshToken(String token);

  /// Retrieve the refresh token
  Future<String?> getRefreshToken();

  /// Delete the refresh token
  Future<void> deleteRefreshToken();

  /// Clear all stored tokens (used for logout)
  Future<void> clearTokens();
}
