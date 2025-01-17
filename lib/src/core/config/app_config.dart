class AppConfig {
  static const String apiBaseUrl = 'http://localhost:5598';
  static const int connectTimeout = 15000; // in milliseconds
  static const int receiveTimeout = 15000;

  // Add environment-specific keys or configurations
  static const String googleApiKey = 'GOOGLE_API_KEY_HERE';
  static const String appVersion = '1.0.0';
}
