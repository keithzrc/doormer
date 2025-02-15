import 'package:logger/logger.dart';

class AppLogger {
  static Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warn(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message);
  }

  // Add a disable method that sets the logger to a no-op logger.
  static void disable() {
    _logger = Logger(
      level: Level.nothing,
    );
  }
}
